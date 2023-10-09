class Nox < Formula
  include Language::Python::Virtualenv

  desc "Flexible test automation for Python"
  homepage "https://nox.thea.codes/"
  url "https://files.pythonhosted.org/packages/e7/3b/529fa8920b18b92085ed5923caee4aee112c65a7af99b34bd5a868b82e3e/nox-2023.4.22.tar.gz"
  sha256 "46c0560b0dc609d7d967dc99e22cb463d3c4caf54a5fda735d6c11b5177e3a9f"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1cb418211bac4b369ad93d1bdf51cac003113fcc361dd34060737d0e8cead4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e32fe2c4bd1e0d4b101a990e2d7174097779ec0a93bd013dba04aa99e3244733"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac06b406f6b875109ee86044ae6b822e175ead8269ae1ef53e847ae273486731"
    sha256 cellar: :any_skip_relocation, sonoma:         "3380e6a697bde13617c8b897fe95f263847a01894a1286094da603be7e77ad4c"
    sha256 cellar: :any_skip_relocation, ventura:        "5be0e08ceb598e48f6120d753c324a87ceaf9a0dd0a71e6479bc0eff7458380a"
    sha256 cellar: :any_skip_relocation, monterey:       "c3046dad602d43e6eb551ce2a176a966edc0618906e52c5b0fb0fbc628829bf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c72763e65f0dab528889bf4c0816d1ff58742d4ca678c30e50b99a5eb5bddd17"
  end

  depends_on "python-packaging"
  depends_on "python@3.11"
  depends_on "six"
  depends_on "virtualenv"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6e/5b/9eae020dad132502efdb51408ba8a5b21afedcb738a98a307c6bfc21aaa8/argcomplete-3.0.6.tar.gz"
    sha256 "9fe49c66ba963b81b64025f74bfbd0275619a6bde1c7370654dc365d4ecc9a0b"
  end

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
