class Nox < Formula
  include Language::Python::Virtualenv

  desc "Flexible test automation for Python"
  homepage "https://nox.thea.codes/"
  url "https://files.pythonhosted.org/packages/e7/3b/529fa8920b18b92085ed5923caee4aee112c65a7af99b34bd5a868b82e3e/nox-2023.4.22.tar.gz"
  sha256 "46c0560b0dc609d7d967dc99e22cb463d3c4caf54a5fda735d6c11b5177e3a9f"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0366cd6438c73ef6d03c7ce027b1db637e5d5db7ac23e38c3ecbe09ff3a491b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1259e8647bc51b77258f5d57937536aeb7263ae0916d234771fcb70fd0ee5d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b02bf90dcd4f94b528c0d87f0e425cd1e68b8a253f2ade64f859a9bdfac025fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e45663ae856784bf11b3a3f82181ab3ce9cf0939366945e5116b75cbdc30225"
    sha256 cellar: :any_skip_relocation, ventura:        "e8101df246aeeebd6cab980682dbc8e36e04c731b108ad478126e49adac7f137"
    sha256 cellar: :any_skip_relocation, monterey:       "845b91f1dca59bab4c5fbd163a4ad2d1b7163e97b7131b25b515477f8f60fc8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc0322d571d662edf0f631735018af8fb4888fb141b7b9d3aae7117c74de8d66"
  end

  depends_on "python-argcomplete"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "virtualenv"

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/78/6b/4e5481ddcdb9c255b2715f54c863629f1543e97bc8c309d1c5c131ad14f2/colorlog-6.7.0.tar.gz"
    sha256 "bd94bd21c1e13fac7bd3153f4bc3a7dc0eb0974b8bc2fdf1a989e474f6e582e5"
  end

  def install
    virtualenv_install_with_resources
    (bin/"tox-to-nox").unlink

    # we depend on virtualenv, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.12")
    virtualenv = Formula["virtualenv"].opt_libexec
    (libexec/site_packages/"homebrew-virtualenv.pth").write virtualenv/site_packages
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"noxfile.py").write <<~EOS
      import nox

      @nox.session
      def tests(session):
          session.install("pytest")
          session.run("pytest")
    EOS
    (testpath/"test_trivial.py").write <<~EOS
      def test_trivial():
          assert True
    EOS
    assert_match "usage", shell_output("#{bin}/nox --help")
    assert_match "Sessions defined in #{testpath}/noxfile.py", shell_output("#{bin}/nox --list-sessions")
  end
end
