class Ipatool < Formula
  desc "CLI tool for searching and downloading app packages from the iOS App Store"
  homepage "https://github.com/majd/ipatool"
  url "https://github.com/majd/ipatool/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "1354d2d11a71e1e1534c731f9fd544c04fcf298e321de8cf59d9574e61b1ff11"
  license "MIT"
  head "https://github.com/majd/ipatool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3b4dc8fe623867733131cb36ccdbd24ad5bb0283694090b88f9d8d4367c89087"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "389a5b06668b57ff262710fcd24fc6b5316da85c39e053ba5a465e8164b8747a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9051a6494f400c928f8588729d4b39af4fa8ac5d178ce14d850ee228fa892407"
    sha256 cellar: :any,                 arm64_linux:       "06e59e1144fe593e182357014eb799e9b231be55f881de1142d329cab59f87f8"
    sha256 cellar: :any,                 x86_64_linux:      "a516568bb625df0cb53884e7ddf227e17dc4f1c5a99a1aadbcaef112fc460646"
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
