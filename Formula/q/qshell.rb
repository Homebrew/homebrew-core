class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.19.2.tar.gz"
  sha256 "ef14065ac64558a85208fbf794a52ce3a4ea1ba16b6a28d6524ef4746109427a"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dfc3299c08d043a5973a6b5a44b83f7f386349d8f8b5cacaba53c845df5ea6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dfc3299c08d043a5973a6b5a44b83f7f386349d8f8b5cacaba53c845df5ea6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dfc3299c08d043a5973a6b5a44b83f7f386349d8f8b5cacaba53c845df5ea6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e63ede22b5fab3fd433926416a0dd5a4023e0906faacf1b2f8c33fa6bffd0b61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "daa3c9457cd87361489dcb268be5ac1345febaadb1be6baa3092fa43eebe82ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "287410f43b63fad03fd8be4943687482582eff0c47e58465d09384709c73b7d2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/qiniu/qshell/v2/iqshell/common/version.version=v#{version}
    ]
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
