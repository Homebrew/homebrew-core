class Arti < Formula
  desc "Implementation of Tor in Rust"
  homepage "https://gitlab.torproject.org/tpo/core/arti"
  url "https://gitlab.torproject.org/tpo/core/arti/-/archive/arti-v1.2.0/arti-arti-v1.2.0.tar.bz2"
  sha256 "1ce0d795e26fa21d200910cc8f0238c4e7f84a8d22d9fc428328ac5b0b0d7a99"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "xz" # for liblzma
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--features", "accel-openssl", *std_cargo_args(path: "crates/arti")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    # failed with `Can't listen on [::1]:xx: Cannot assign requested address (os error 99)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    port = free_port
    test_config = testpath/"arti.toml"

    test_config.write <<~EOS
      [proxy]
      socks_listen = #{port}

      [logging]
      console = "info"
    EOS

    assert_match version.to_s, shell_output("#{bin}/arti --version")

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"arti", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end

    pid = fork { exec bin/"arti", "proxy", "-c", test_config }
    sleep 1

    output = shell_output("curl -I --socks5-hostname 127.0.0.1:#{port} https://www.example.com")
    assert_match "HTTP/2 200", output
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
