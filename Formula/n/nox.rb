class Nox < Formula
  include Language::Python::Virtualenv

  desc "Flexible test automation for Python"
  homepage "https://nox.thea.codes/"
  url "https://files.pythonhosted.org/packages/e7/3b/529fa8920b18b92085ed5923caee4aee112c65a7af99b34bd5a868b82e3e/nox-2023.4.22.tar.gz"
  sha256 "46c0560b0dc609d7d967dc99e22cb463d3c4caf54a5fda735d6c11b5177e3a9f"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7396784718da1913b1e808a0a1e091e5f203e417021fd665f2985245926c4b82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6685fae11a657a3fa86a16c7a188f9b8db3edeb6dc605b7bf48aa019379018d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b12be93bdde091b679d7e75210a3dd3d4830b4ad5c15b2f1ac27239e6309ea9"
    sha256 cellar: :any_skip_relocation, sonoma:         "85157c5afe14c28fcbc06dd445221d5933c88581ad6f694ef9461d10d2a36a5a"
    sha256 cellar: :any_skip_relocation, ventura:        "fe754a69aeb0d7c48d5a24ae076165848394578d3fb22660e3712cd6808adce0"
    sha256 cellar: :any_skip_relocation, monterey:       "7d94ac0b5451bcd55c3be072a2d3ac56e8b7643f8c3bb974a2d80c2d6791361d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "467474223287f45c612c5396309eb5472dabaf1e7c88c4806cbf4b952a127a8f"
  end

  depends_on "python-argcomplete"
  depends_on "python-packaging"
  depends_on "python@3.11"
  depends_on "six"
  depends_on "virtualenv"

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/78/6b/4e5481ddcdb9c255b2715f54c863629f1543e97bc8c309d1c5c131ad14f2/colorlog-6.7.0.tar.gz"
    sha256 "bd94bd21c1e13fac7bd3153f4bc3a7dc0eb0974b8bc2fdf1a989e474f6e582e5"
  end

  def install
    virtualenv_install_with_resources
    (bin/"tox-to-nox").unlink

    # we depend on virtualenv, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
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
