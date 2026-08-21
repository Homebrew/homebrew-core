class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.19.12.tar.gz"
  sha256 "47c9c466f83de9d978ddfa62f6066733d7deed7082049ec645d9bb40b892b61f"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cbb3aab95d72e1d49e1dea80fd06996542811abbd7695d72b3c2a5a8c9ae00b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cbb3aab95d72e1d49e1dea80fd06996542811abbd7695d72b3c2a5a8c9ae00b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cbb3aab95d72e1d49e1dea80fd06996542811abbd7695d72b3c2a5a8c9ae00b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d205e9bb56c3411afbf9fac88873490ce5c6aac688591efd9c23f9391680fd2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ce82e7beaafb70f40ff69d470e2fff38008889f9b34dedd09028f77576f35b6"
    sha256 cellar: :any,                 x86_64_linux:  "42c316c3369fb350a58afe1ac110801c6d11f3daf991101a52b9edeab1d99c5e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/qiniu/qshell/v2/iqshell/common/version.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:), "./main"
    generate_completions_from_executable(bin/"qshell", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output "#{bin}/qshell -v"
    assert_match "qshell version v#{version}", output

    # Test base64 encode of string "abc"
    output2 = shell_output "#{bin}/qshell b64encode abc"
    assert_match "YWJj", output2
  end
end
