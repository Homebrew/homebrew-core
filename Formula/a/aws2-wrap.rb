class Aws2Wrap < Formula
  include Language::Python::Virtualenv

  desc "Script to export current AWS SSO credentials or run a sub-process with them"
  homepage "https://github.com/linaro-its/aws2-wrap"
  url "https://files.pythonhosted.org/packages/6d/c7/8afdf4d0c7c6e2072c73a0150f9789445af33381a611d33333f4c9bf1ef6/aws2-wrap-1.4.0.tar.gz"
  sha256 "77613ae13423a6407e79760bdd35843ddd128612672a0ad3a934ecade76aa7fc"
  license "GPL-3.0-only"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3268822bfc1e7e701d18bdc33ab3e1da2dbade82654349196575813f596fa2ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4273b2ffc121cdec548f58a6fe95ee8b48ec81302d2aeaffc7988d480c74b487"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "162278b196ec4ea96fa0c358d6375ee2728591d89dd577aa619097fe897bf9c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2ea3565616d3ae6d2242997f570c236bd9b0f2bc9df70c5a4963ff78f0ba027"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bce412d5705b5db7d2bd526f20e9da030b4c4c0404bab9a9d7c3de6608ebbbb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cadb8097812a3729fb1ae6d91eec08399280c4096cc4d4d79423ce3924b445b5"
  end

  deprecate! date: "2025-10-02", because: :repo_archived

  depends_on "python@3.14"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/b3/31/4723d756b59344b643542936e37a31d1d3204bcdc42a7daa8ee9eb06fb50/psutil-7.1.0.tar.gz"
    sha256 "655708b3c069387c8b77b072fc429a57d0e214221d01c0a772df7dfedcb3bcd2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir testpath/".aws"
    touch testpath/".aws/config"
    ENV["AWS_CONFIG_FILE"] = testpath/".aws/config"

    assert_match "Cannot find profile 'default'", shell_output("#{bin}/aws2-wrap 2>&1", 1).strip
  end
end
