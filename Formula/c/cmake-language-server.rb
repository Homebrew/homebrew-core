class CmakeLanguageServer < Formula
  include Language::Python::Virtualenv

  desc "Language Server for CMake"
  homepage "https://github.com/regen100/cmake-language-server"
  url "https://files.pythonhosted.org/packages/cc/ce/4b14dcaac4359fc9bdcb823763c7984b72e16ff2bf1c709bbc963cc0e0bc/cmake_language_server-0.1.10.tar.gz"
  sha256 "dbc627dc1e549fc7414f459bdb340812acd84a0c8727b92e73c4bd348e6311bf"
  license "MIT"
  head "https://github.com/regen100/cmake-language-server.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "86cdbf04946f27a7004d51e49f0513c6d0a77835289c1299da6653a5ec5f41aa"
  end

  depends_on "python@3.13"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/1e/57/c6ccd22658c4bcb3beb3f1c262e1f170cf136e913b122763d0ddd328d284/cattrs-23.2.3.tar.gz"
    sha256 "a934090d95abaa9e911dac357e3a8699e0b4b14f8529bcc7d2b1ad9d51672b9f"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/9d/f6/6e80484ec078d0b50699ceb1833597b792a6c695f90c645fbaf54b947e6f/lsprotocol-2023.0.1.tar.gz"
    sha256 "cc5c15130d2403c18b734304339e51242d3018a05c4f7d0f198ad6e0cd21861d"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/86/b9/41d173dad9eaa9db9c785a85671fc3d68961f08d67706dc2e79011e10b5c/pygls-1.3.1.tar.gz"
    sha256 "140edceefa0da0e9b3c533547c892a42a7d2fd9217ae848c330c53d266a55018"
  end

  # py3.13 build patch, upstream pr ref, https://github.com/regen100/cmake-language-server/pull/94
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"

    output = pipe_output(bin/"cmake-language-server", input)

    assert_match(/^Content-Length: \d+/i, output)

    assert_match version.to_s, shell_output("#{bin}/cmake-language-server --version")
  end
end

__END__
diff --git a/PKG-INFO b/PKG-INFO
index 5f7bdbd..c47c4f2 100644
--- a/PKG-INFO
+++ b/PKG-INFO
@@ -13,7 +13,7 @@ Classifier: Topic :: Software Development
 Classifier: Topic :: Text Editors :: Integrated Development Environments (IDE)
 Classifier: Topic :: Utilities
 Project-URL: Repository, https://github.com/regen100/cmake-language-server
-Requires-Python: <3.13,>=3.8.0
+Requires-Python: <3.14,>=3.8.0
 Requires-Dist: pygls>=1.1.1
 Description-Content-Type: text/markdown
 
diff --git a/pyproject.toml b/pyproject.toml
index efff6d2..9e6b1c1 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -8,7 +8,7 @@ authors = [
 dependencies = [
     "pygls>=1.1.1",
 ]
-requires-python = ">=3.8.0,<3.13"
+requires-python = ">=3.8.0,<3.14"
 readme = "README.md"
 keywords = [
     "cmake",
