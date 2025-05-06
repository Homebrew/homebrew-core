class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/pylint-dev/pylint"
  url "https://files.pythonhosted.org/packages/1c/e4/83e487d3ddd64ab27749b66137b26dc0c5b5c161be680e6beffdc99070b3/pylint-3.3.7.tar.gz"
  sha256 "2b11de8bde49f9c5059452e0c310c079c746a0a8eeaa789e5aa966ecc23e4559"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79a2fd54f5ec3e5e174319d1a93bd2c2fda90209a405694ef6a4a3540965ec5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79a2fd54f5ec3e5e174319d1a93bd2c2fda90209a405694ef6a4a3540965ec5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79a2fd54f5ec3e5e174319d1a93bd2c2fda90209a405694ef6a4a3540965ec5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "be7aadfecc2d88f2aaea4047fe52024444cb92943e3d73bee049a0d71e8f6bfa"
    sha256 cellar: :any_skip_relocation, ventura:       "be7aadfecc2d88f2aaea4047fe52024444cb92943e3d73bee049a0d71e8f6bfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "777c0a4c91cbe15b862df038ffdb7fb2ab415ad6fb691d6469794308b7eb63bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "777c0a4c91cbe15b862df038ffdb7fb2ab415ad6fb691d6469794308b7eb63bd"
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
    url "https://files.pythonhosted.org/packages/39/33/536530122a22a7504b159bccaf30a1f76aa19d23028bd8b5009eb9b2efea/astroid-3.3.9.tar.gz"
    sha256 "622cc8e3048684aa42c820d9d218978021c3c3d174fb03a9f0d615921744f550"
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
    url "https://files.pythonhosted.org/packages/b6/2d/7d512a3913d60623e7eb945c6d1b4f0bddf1d0b7ada5225274c87e5b53d1/platformdirs-4.3.7.tar.gz"
    sha256 "eb437d586b6a0986388f0d6f74aa0cde27b48d0e3d66843640bfb6bdcdb6e351"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/b1/09/a439bec5888f00a54b8b9f05fa94d7f901d6735ef4e55dcec9bc37b5d8fa/tomlkit-0.13.2.tar.gz"
    sha256 "fff5fe59a87295b278abd31bec92c15d9bc4a06885ab12bcea52c71119392e79"
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
