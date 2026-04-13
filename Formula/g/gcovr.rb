class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/07/37/b4a87dff166dc0a5002e9d03fcb6ca8eeff048247b011b67f047e31122c9/gcovr-8.6.tar.gz"
  sha256 "b2e7042abca9321cadbab8a06eb34d19f801b831557b28cdc30a029313de8b9e"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/gcovr/gcovr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "038683f938a7f7161176ef216f7401a658bc452b31ef9c6158d1e5326925680f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "309390e59634acc9bde77bdff1966fdfdb523446482f0a8b5f69793359a9b50f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74f9e73650de5b102656e013c741e2a766910986c848d7f39ff349fac609cfbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "68d8f406a35a94b0bcd1bcbfe0f6c846670acd16ce3177002b5ef22f787555ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a14eb024ffea986379a1aeea09abe904f9daa4e9e4e7a52ef0d74afeb15902f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db2fdb613a0b0a0c3aec5efa3e503cc4e822ef16b817a685e5b2d1f4a06f36e3"
  end

  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/a2/61/f083b5ac52e505dfc1c624eafbf8c7589a0d7f32daa398d2e7590efa5fda/colorlog-6.10.1.tar.gz"
    sha256 "eb4ae5cb65fe7fec7773c2306061a8e63e02efc2c72eba9d27b0fa23c94f1321"
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
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
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
