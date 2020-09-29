class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost.git",
      tag:      "v0.6.0",
      revision: "ee7f695a199b1ab699cc995a3d5b381088ae2006"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "228f812004b507dfdb0f1e3bae53801c0b89c10c6e3732a87d2b8b50ea1cb31c" => :catalina
    sha256 "c2d156a7993820f8dd95450389907957c916702673129643bcd856624b776eb3" => :mojave
    sha256 "6f2a3449c100879206e76aba5eda987c690e95a900b20145936f645bf207ccaf" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    system "git", "--version"
    system "make", "install"
    bin.install Dir["#{ENV["GOPATH"]}/bin/infracost"]
  end

  test do
    output = shell_output("#{bin}/infracost --no-color", result = 1)
    assert_equal output.lines.first, "No INFRACOST_API_KEY environment variable is set.\n"
  end
end
