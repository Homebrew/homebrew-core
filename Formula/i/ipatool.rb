class Ipatool < Formula
  desc "CLI tool for searching and downloading app packages from the iOS App Store"
  homepage "https://github.com/majd/ipatool"
  url "https://github.com/majd/ipatool/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "88704a28231ac0019016c1900edebc9dea0cf14de4e5bc90aa96fd594925bdc0"
  license "MIT"
  head "https://github.com/majd/ipatool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f44cad22f936f7c7cdb306305b3687d461387c0a9dac26ce2321092920d1657d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2da81f3f87359994a13d7773524ed773abaa20ac4b56340415993a12cf1b20ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "49d19d0d369780dab3169bb2de88262244e9a79a98d4a28bd2b2fafa0928026d"
    sha256 cellar: :any,                 arm64_linux:       "6965b76c1e3e68bde1525dbff85d961e3d87dd1062d2199351cb6e5ca9bb7fd9"
    sha256 cellar: :any,                 x86_64_linux:      "ed50b74b7fa0758706ddea746f1b5d4ee925374ef6efd4f2ffc3962f830b9951"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-X github.com/majd/ipatool/v2/cmd.version=#{version}")

    generate_completions_from_executable(bin/"ipatool", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipatool --version")

    output = shell_output("#{bin}/ipatool auth info 2>&1", 1)
    assert_match "failed to get account", output
  end
end
