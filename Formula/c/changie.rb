class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://github.com/miniscruff/changie/archive/refs/tags/v1.24.2.tar.gz"
  sha256 "57eab8209ed18e938ddb033fb6e3bd62229d442da728f7e75027d4117716ba57"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8501d7618a56655fde8baf855b57fd085a8df481e5252dd45f4997779156a55f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8501d7618a56655fde8baf855b57fd085a8df481e5252dd45f4997779156a55f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8501d7618a56655fde8baf855b57fd085a8df481e5252dd45f4997779156a55f"
    sha256 cellar: :any_skip_relocation, sonoma:        "081b7d9f6002c817366c768b86e5042a7c2b3fa227e01d2bd0495afff5baa8ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6daf8a737cf8e503180d588bce6fef87fa01e867e69756ed61d8b4e8f95cdc59"
    sha256 cellar: :any,                 x86_64_linux:  "23cc7e1f660593c8591e3472b528f754055ed2b93d955902900d8a6e611aee4c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"changie", shell_parameter_format: :cobra)
  end

  test do
    system bin/"changie", "init"
    assert_match "All notable changes to this project", (testpath/"CHANGELOG.md").read

    assert_match version.to_s, shell_output("#{bin}/changie --version")
  end
end
