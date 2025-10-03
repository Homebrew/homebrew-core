class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/pylint-dev/pylint"
  url "https://files.pythonhosted.org/packages/9d/58/1f614a84d3295c542e9f6e2c764533eea3f318f4592dc1ea06c797114767/pylint-3.3.8.tar.gz"
  sha256 "26698de19941363037e2937d3db9ed94fb3303fdadf7d98847875345a8bb6b05"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "d4ddb8cfcd18ad93fe22e7f0fb7d3d77dcda84e6f3c2728463caa7f494e51f21"
  end

  depends_on "python@3.13"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/39/33/536530122a22a7504b159bccaf30a1f76aa19d23028bd8b5009eb9b2efea/astroid-3.3.9.tar.gz"
    sha256 "622cc8e3048684aa42c820d9d218978021c3c3d174fb03a9f0d615921744f550"

    # fix `setuptools.errors.InvalidConfigError: 'project.license-files' is defined already`
    # commit ref, https://github.com/pylint-dev/astroid/commit/9faee90fdb66049162834a8bb066c6cb40a0e449
    patch :DATA
  end

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/18/74/dfb75f9ccd592bbedb175d4a32fc643cf569d7c218508bfbd6ea7ef9c091/astroid-3.3.11.tar.gz"
    sha256 "1e5a5011af2920c7c67a53f65d536d65bfa7116feeaf2354d8b94f29573bb0ce"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/12/80/630b4b88364e9a8c8c5797f4602d0f76ef820909ee32f0bacb9f90654042/dill-0.4.0.tar.gz"
    sha256 "0633f1d2df477324f53a895b02c901fb961bdbf65a17122586ea7019292cbcf0"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/b8/21/1e2a441f74a653a144224d7d21afe8f4169e6c7c20bb13aec3a2dc3815e0/isort-6.0.1.tar.gz"
    sha256 "1cb5df28dfbc742e490c5e41bad6da41b805b0a8be7bc93cd0fb2a8a890ac450"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/23/e8/21db9c9987b0e728855bd57bff6984f67952bea55d6f75e055c46b5383e8/platformdirs-4.4.0.tar.gz"
    sha256 "ca753cf4d81dc309bc67b0ea38fd15dc97bc30ce419a7f58d13eb3bf14c4febf"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/cc/18/0bbf3884e9eaa38819ebe46a7bd25dcd56b67434402b66a58c4b8e552575/tomlkit-0.13.3.tar.gz"
    sha256 "430cf247ee57df2b94ee3fbe588e71d362a941ebb545dec29b53961d61add2a1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"pylint_test.py").write <<~PYTHON
      print('Test file'
      )
    PYTHON
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end

__END__
diff --git a/pyproject.toml b/pyproject.toml
index b0078e8..fcc3996 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -4,15 +4,15 @@ build-backend = "setuptools.build_meta"

 [project]
 name        = "astroid"
-license     = {text = "LGPL-2.1-or-later"}
 description = "An abstract syntax tree for Python with inference support."
 readme      = "README.rst"
 keywords    = ["static code analysis", "python", "abstract syntax tree"]
+license     = "LGPL-2.1-or-later"
+license-files = [ "LICENSE", "CONTRIBUTORS.txt" ]
 classifiers = [
     "Development Status :: 6 - Mature",
     "Environment :: Console",
     "Intended Audience :: Developers",
-    "License :: OSI Approved :: GNU Lesser General Public License v2 (LGPLv2)",
     "Operating System :: OS Independent",
     "Programming Language :: Python",
     "Programming Language :: Python :: 3",
@@ -40,9 +40,6 @@ dynamic = ["version"]
 "Bug tracker"    = "https://github.com/pylint-dev/astroid/issues"
 "Discord server" = "https://discord.gg/Egy6P8AMB5"

-[tool.setuptools]
-license-files = ["LICENSE", "CONTRIBUTORS.txt"]  # Keep in sync with setup.cfg
-
 [tool.setuptools.package-dir]
 "" = "."
