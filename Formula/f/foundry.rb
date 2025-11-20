class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  url "https://github.com/foundry-rs/foundry/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "83115cef588a709b0126c790dc3c4654226a038c9a33f83d0785ef36cde1af6f"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2d5ae0008cde9baafc5701c02b4ab9020f22e3acf929d184614bb2731d9df58c"
    sha256 cellar: :any,                 arm64_sequoia: "488d9566845cc67ac20e69dd60f24e611eaf2376c9f81460da19f3cc99cb25b7"
    sha256 cellar: :any,                 arm64_sonoma:  "e5caa4dd17256c4c2f9ff3f7408328a083ec3449e4e3655745635900abfdc2f2"
    sha256 cellar: :any,                 sonoma:        "99a418fb8749f5509d5693f59ba3313294b354c35e6822a7970e08626163b3ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86fed7af9f92b9737a56f73142535626b8c72363b6d07de93162af5715d429a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0947520194dd646519cbe18c0e755b0c084039f4a2aba710b81a90563f4cf6db"
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

    assert_match "Decimal: 2\n", pipe_output("#{bin}/chisel", "1+1")

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
