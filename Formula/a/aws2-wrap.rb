class Aws2Wrap < Formula
  include Language::Python::Virtualenv

  desc "Script to export current AWS SSO credentials or run a sub-process with them"
  homepage "https://github.com/linaro-its/aws2-wrap"
  url "https://files.pythonhosted.org/packages/6d/c7/8afdf4d0c7c6e2072c73a0150f9789445af33381a611d33333f4c9bf1ef6/aws2-wrap-1.4.0.tar.gz"
  sha256 "77613ae13423a6407e79760bdd35843ddd128612672a0ad3a934ecade76aa7fc"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c2df355539ff6a5a97dc6576094fdf500f880d7943bc98d18bdd1bb05eb7a2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ea2d064799ec9632c9ec0550c5adf25b7f729281a69ab8f9ef3f0bf08d9d0d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e8245761543dba5a8c40024e84c3f4804231dd5ae4017fa8e661bf82d53005a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3586cb80290225eb4ca995f8adf04bd4823d436c27c2329721954887b7e77ba8"
    sha256 cellar: :any_skip_relocation, ventura:        "83c88c4352544d1ae1de1d10d5d2df6fce10d0e84fa3b484d90ef679575da4d6"
    sha256 cellar: :any_skip_relocation, monterey:       "3563f2e6d3584c99437b9d0e1af6703c3f2a7ebcb8157a35bd3e58d987420270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a9f4369e5f248a94f80ef4cec4efe6990f2386a31014de607e764f9a564490d"
  end

  depends_on "python@3.12"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir testpath/".aws"
    touch testpath/".aws/config"
    ENV["AWS_CONFIG_FILE"] = testpath/".aws/config"
    assert_match "Cannot find profile 'default'",
      shell_output("#{bin}/aws2-wrap 2>&1", 1).strip
  end
end
