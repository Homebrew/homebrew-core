class Ktop < Formula
  desc "Top-like tool for your Kubernetes clusters"
  homepage "https://github.com/vladimirvivien/ktop"
  url "https://github.com/vladimirvivien/ktop/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "9da9efe50e4a5a75c61f84e3dcf4e491e152f7bcb680181ca05fc34fcc3f2cfd"
  license "Apache-2.0"
  head "https://github.com/vladimirvivien/ktop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c05152599c4180b1055c06e565244998df19c8d71a274f6377556a5aff76e3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48dd4dd7ec729297c853f43f2deb8d340520c37bf6fb8043d13b02d568bb9c83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "809d4f135287d89bd5f760c59ec9b71e3b60a84c62bfa5cb5608b2f6b01ccd46"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c2c0d3155fcae7d0448a458f2dcc1ded30745a036c5f3022b382dc637f31431"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d0dae9a751211ab5f13cfae5203ca4ac54cff76961ad6775dd02f900d93fd3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aeca0be2eb95b110e34bfe32d91616628e58ff0956f6979d2438a4f582507430"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vladimirvivien/ktop/buildinfo.Version=#{version}
      -X github.com/vladimirvivien/ktop/buildinfo.GitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/ktop --all-namespaces 2>&1", 1)
    assert_match "connection refused", output
  end
end
