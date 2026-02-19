class Koji < Formula
  desc "Interactive CLI for creating conventional commits"
  homepage "https://github.com/cococonscious/koji"
  url "https://github.com/cococonscious/koji/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "fe3a56bc7f0829d434b82d8bda51c6cae7dbc909a1ae7980b31c63338349af73"
  license "MIT"
  head "https://github.com/cococonscious/koji.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "2c2e65370ee4b66b797d400a6435446d2e23865f30f17d5b043981827071fe03"
    sha256 cellar: :any,                 arm64_sequoia: "9dc61a06ca85e589e22edb4f49138080b8c465b4eb07fd786f570bfbe67484dc"
    sha256 cellar: :any,                 arm64_sonoma:  "92223e83af0921779e26588f9a01b5ce030ef31dd5f0646a9fa25f8716b61541"
    sha256 cellar: :any,                 sonoma:        "d48affcaca82ec955947353707efecb5c1587dbf2178c2f3e309637f6b2228fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3222f067b938c91e5be8d5bf9f5f5a17689e46bddbf43be19eaee6fe498b7e9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4d4ac52c1cf5615952acd1d35bd1b70060812a0f91ca55a04714e9674efc73b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"koji", "completions")
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/koji --version")

    require "pty"
    ENV["TERM"] = "xterm"

    # setup git
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"

    PTY.spawn(bin/"koji") do |r, w, _pid|
      w.puts "feat"
      w.puts "test"
      w.puts "test"
      w.puts "test"
      w.puts "No"
      w.puts "No"
      begin
        output = r.read
        assert_match "Does this change affect any open issues", output
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"koji", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
