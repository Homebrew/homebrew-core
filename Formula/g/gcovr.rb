class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/07/37/b4a87dff166dc0a5002e9d03fcb6ca8eeff048247b011b67f047e31122c9/gcovr-8.6.tar.gz"
  sha256 "b2e7042abca9321cadbab8a06eb34d19f801b831557b28cdc30a029313de8b9e"
  license "BSD-3-Clause"
  head "https://github.com/gcovr/gcovr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49fb3d1e586e2f9dc1cd64e58167158f38a8246f3014943327abcff092aa2bdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3ed44ba1b42ef26b474a36f17251e2d538d42c98aa8bf5c55ad82a56a932df7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dee9c6126251e0b9492ab42dce9c630a4b8f1a9ea504abaa7009bcfa2190819"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ff642a465d7cefa35c1e8708bd3a2699b806105bf835102dfcf521bfe78f1f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2833433cdbd2cd88bb6fca30ac2152e89fd4b4346f26657cace31524fe055f89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "798eca898b3c7345e82eb9240b05a0b60ca803fb202c9b602f01daa85caefb62"
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
