class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  url "https://github.com/foundry-rs/foundry/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "6c2e543baadc3bf2cdaf44fe1e916e0c27501a333ddc56f15ee0aea5ace90cb3"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "help2man" => :build
  depends_on "rust" => :build

  on_macos do
    # https://github.com/foundry-rs/foundry/blob/51b75c83045a963a48f9cd8d765e0f2e775acb3e/foundryup/install#L56-L59
    depends_on "libusb"
  end

  def binaries
    %w[forge cast anvil chisel].freeze
  end

  def install
    if build.stable?
      ENV["TAG_NAME"] = "stable"
      ENV["VERGEN_GIT_SHA"] = tap.user.ljust(40)
    end

    binaries.each do |binary|
      system "cargo", "install", "--bin", binary, *std_cargo_args(path: "crates/#{binary}")

      # https://book.getfoundry.sh/config/shell-autocompletion
      generate_completions_from_executable(bin/binary.to_s, "completions") if binary != "chisel"

      system "help2man", bin/binary.to_s, "-o", "#{binary}.1", "-N"
      man1.install "#{binary}.1"
    end
  end

  test do
    project = testpath/"project"
    project.mkpath
    cd project do
      # forge init will create an initial git commit, which will fail if an email is not set.
      ENV["EMAIL"] = "example@example.com"
      system bin/"forge", "init"
      assert_path_exists project/"foundry.toml"
      assert_match "Suite result: ok.", shell_output("#{bin}/forge test")
    end

    assert_match "Decimal: 2\n", pipe_output(bin/"chisel", "1+1")

    anvil_port = free_port
    anvil = fork do
      exec bin/"anvil", "--port", anvil_port.to_s
    end
    sleep 2
    assert_equal "31337", shell_output("#{bin}/cast cid -r 127.0.0.1:#{anvil_port}").chomp
  ensure
    if anvil
      Process.kill("TERM", anvil)
      Process.wait anvil
    end
  end
end
