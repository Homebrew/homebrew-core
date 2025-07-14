class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  url "https://github.com/foundry-rs/foundry/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "856c8b5cab39f1e6dd27ee368a306add7604d1c720148763cfd599cce4e1a510"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1b454bbd8373f55cfeef658fdbc4eacf914699b7a0c2a2fc50415b001b5abcd8"
    sha256 cellar: :any,                 arm64_sonoma:  "32821e29862e266191f07a773c09b92c8d8c9650e93d4aad8e9df2873820fbc0"
    sha256 cellar: :any,                 arm64_ventura: "19c07a7f6a649dd08a9dadb9fd9e610b72cd9a14537f05bdca0565d38e0096ac"
    sha256 cellar: :any,                 sonoma:        "ca39ddcbf3b1a8fc9ac52c2fa8ff738f1df6b789c15348b0a3f6ccd245a197ab"
    sha256 cellar: :any,                 ventura:       "211ac10d0440a54ef4e4d322804a438ff5a1bb7df5c54f7c1e7c8dba55bfcc2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35eabf01a8bf421c25fc044e58544c958e5eec0980a569681e90e102b0d3e5c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d3886cc949dce5f70e29e93f0a33db11a342d2970250ad036561833d3a68224"
  end

  depends_on "help2man" => :build
  depends_on "rust" => :build

  on_macos do
    depends_on "libusb"
  end

  conflicts_with "chisel-tunnel", because: "both install `chisel` binaries"
  conflicts_with "jboss-forge", because: "both install `forge` binaries"

  def install
    ENV["TAG_NAME"] = tap.user

    %w[forge cast anvil chisel].each do |binary|
      system "cargo", "install", *std_cargo_args(path: "crates/#{binary}")

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
    anvil = spawn bin/"anvil", "--port", anvil_port.to_s
    sleep 2
    assert_equal "31337", shell_output("#{bin}/cast cid -r 127.0.0.1:#{anvil_port}").chomp
  ensure
    if anvil
      Process.kill("TERM", anvil)
      Process.wait anvil
    end
  end
end
