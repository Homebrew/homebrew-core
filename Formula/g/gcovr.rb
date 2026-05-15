class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/07/37/b4a87dff166dc0a5002e9d03fcb6ca8eeff048247b011b67f047e31122c9/gcovr-8.6.tar.gz"
  sha256 "b2e7042abca9321cadbab8a06eb34d19f801b831557b28cdc30a029313de8b9e"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/gcovr/gcovr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6265636e24087c0242e1f62f319fe862e8212f6605724bb089ee6f9478982462"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c91e85b8d3665cc865dbed4f86e6b125c0d510eebdfd65c8b894ac55bab4dd1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "093f459d8b5c0c354933fb57054118eb3811b5fe2679e5e4cb85d6ae6c769632"
    sha256 cellar: :any_skip_relocation, sonoma:        "47eddd0901cae25a5c021dc59274fe5aa9f747ae9492b497ae0c253f0fd9794a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6095be0359be4260dd5bf6df97b3c6f4e5537e9a4bd56378ec124505b5df61ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09fba8ca9f888cc853b640d8d8d41a83ad74f59f25ea338b420586ae7c1513ce"
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
    url "https://files.pythonhosted.org/packages/28/30/9abc9e34c657c33834eaf6cd02124c61bdf5944d802aa48e69be8da3585d/lxml-6.1.0.tar.gz"
    sha256 "bfd57d8008c4965709a919c3e9a98f76c2c7cb319086b3d26858250620023b13"
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
