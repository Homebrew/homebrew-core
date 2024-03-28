class Cfv < Formula
  include Language::Python::Virtualenv

  desc "Test and create various files (e.g., .sfv, .csv, .crc., .torrent)"
  homepage "https://github.com/cfv-project/cfv"
  url "https://files.pythonhosted.org/packages/db/54/c5926a7846a895b1e096854f32473bcbdcb2aaff320995f3209f0a159be4/cfv-3.0.0.tar.gz"
  sha256 "2530f08b889c92118658ff4c447ccf83ac9d2973af8dae4d33cf5bed1865b376"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45d0cc0d275d2abce31dc68f6b588cd2b6542700079e914f5313536069105df4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73de17963f67bb975bfba11b8f3e69ac80a47a7729b5b384082a95241a13ff07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34d37ec148d00f729be8d759b3d9b9dbd146169f5632e5b1027baeb8f1a8d968"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbc8899ec58d62eb0510d40f9d379dcb6c30d95689577e8ddabacccbdbc2cee0"
    sha256 cellar: :any_skip_relocation, ventura:        "5617ab20813e0f0e396bf33cf97ef6ed25e7af735afe7771052b0caa63041440"
    sha256 cellar: :any_skip_relocation, monterey:       "2ece33d693e3d3182fd24bbebe315d5ae40e65795810158caec543ed32ffa3e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebd9e777458f000cd6cdf0fccec16a5c50399a07607f15076519d6cbc181da5d"
  end

  depends_on "python@3.12"

  def install
    # fix man folder location issue
    inreplace "setup.py", "'man/man1'", "'share/man/man1'"

    virtualenv_install_with_resources
  end

  test do
    (testpath/"test/test.txt").write "Homebrew!"
    cd "test" do
      system bin/"cfv", "-t", "sha1", "-C", "test.txt"
      assert_predicate Pathname.pwd/"test.sha1", :exist?
      assert_match "9afe8b4d99fb2dd5f6b7b3e548b43a038dc3dc38", File.read("test.sha1")
    end
  end
end
