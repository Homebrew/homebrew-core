class Nox < Formula
  include Language::Python::Virtualenv

  desc "Flexible test automation for Python"
  homepage "https://nox.thea.codes/"
  url "https://files.pythonhosted.org/packages/e7/3b/529fa8920b18b92085ed5923caee4aee112c65a7af99b34bd5a868b82e3e/nox-2023.4.22.tar.gz"
  sha256 "46c0560b0dc609d7d967dc99e22cb463d3c4caf54a5fda735d6c11b5177e3a9f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d3ed5090b94223d95f5ba8abbb8d5112de339423da57d541e94ab89439035d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e65be811d2a457c78af21a73f7897dfc4d75cbd4c559f29adb2f387b5303a6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "332d48ce9c4da2e1cb52f1edda3b92a471dbbdaa42a64857930faefc0b89bff9"
    sha256 cellar: :any_skip_relocation, ventura:        "1418e1025cd468cf8784bd954a7dcdf7718a4b1da83e9bcbfaf8b169e71f1228"
    sha256 cellar: :any_skip_relocation, monterey:       "59135b3eaed034a371da233fae873babbb1270aac148a6b19f4a9cf36d5fb5b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "62bed763b77dda3faeb98aef921d1993fa11fd6c2b6b58aa3c8e48ff5b65beea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10bee3f89607504f58651106c059b3563f9fcd870bfe7c7553dd4c56f2950bc1"
  end

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

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
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
