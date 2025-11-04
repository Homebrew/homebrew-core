class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/e4/ce/b7516854699f807f58c3c9801ad44de7f51a952be16b62a5948b358f1aa4/gcovr-8.4.tar.gz"
  sha256 "8ea0cf23176b1029f28db679d712ca6477b3807097c3755c135bdc53b51cfa72"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/gcovr/gcovr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6245154c7a888383910468cdb7d7431b15eabc3c01e2e462ef2e865a49c411d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "856453915ec622e2e806e6564115a8b29acc10eb3e8848f517b7f886b9e481c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3001317222ca281652e142c40aaf297e5bf267bf4939fcb5343c7c8fe6ba4c58"
    sha256 cellar: :any_skip_relocation, sonoma:        "15a551d30e43fbd76a9bc724fed4a1de7c3ab719a10bfad5b9e449944cc92d5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91e733bf266a318c07a778a1fa4993b608b8d6a29cacfc5493c69a20903869d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba749608e29a48a382efa802ec17ba1e7f28897ffa2fe586f2af1cee2d3367ef"
  end

  depends_on "python@3.14"

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
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"example.c").write <<~C
      int main() {
        return 0;
      }
    C

    # gcov must match the c compiler version, which is gcc-12 on linux
    ENV["GCOV"] = ENV.cc.sub("gcc", "gcov") if OS.linux?
    system ENV.cc, "--coverage", "-g", "-O0", "-o", "example", "example.c"
    assert_match "Code Coverage Report", shell_output("#{bin}/gcovr")
  end
end
