class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/40/9f/2883275d71f27f81919a7f000afe7eb344496ab74d62e1c0e4a804918b9f/gcovr-8.3.tar.gz"
  sha256 "faa371f9c4a7f78c9800da655107d4f99f04b718d1c0d9f48cafdcbef0049079"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/gcovr/gcovr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bbb80b9db76a6b006d56229948f56abae10a00ede9fe0a4546bddf847d078e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe5e05f6529a00d03b708fa4588b2741d9b7f1df01905a55a4e4dbc6ab254fff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fd089bfa06c18013cae107199c2da512fb7b9c2a4bdb7cdaf260f17931681c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dcdf19da6dd9ac9a6aebc0da570b5a849ecd0f39ef195c287c0f765c933fd96"
    sha256 cellar: :any_skip_relocation, ventura:       "823beec7344b7dce24e94660603d5a4c9b1199ed232803983ee70e92a3a0e992"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2f76e4d8551cc2f636aa90b60a9cffbdb9d6a17dcee8d0ed5c6e5f232887568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bd87ae3e136cf7758e904e80510ff06c6fa8005c42f38beba6e375248f62a19"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/d3/7a/359f4d5df2353f26172b3cc39ea32daa39af8de522205f512f458923e677/colorlog-6.9.0.tar.gz"
    sha256 "bfba54a1b93b94f54e1f4fe48395725a3d92fd2a4af702f6bd70946bdc0c6ac2"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ef/f6/c15ca8e5646e937c148e147244817672cf920b56ac0bf2cc1512ae674be8/lxml-5.3.1.tar.gz"
    sha256 "106b7b5d2977b339f1e97efe2778e2ab20e99994cbb0ec5e55771ed0795920c8"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"example.c").write "int main() { return 0; }"
    system ENV.cc, "-fprofile-arcs", "-ftest-coverage", "-fPIC", "-O0", "-o",
                   "example", "example.c"
    assert_match "Code Coverage Report", shell_output("#{bin}/gcovr -r .")
  end
end
