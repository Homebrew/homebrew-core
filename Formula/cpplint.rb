class Cpplint < Formula
  include Language::Python::Virtualenv

  desc "Static code checker for C++"
  homepage "https://pypi.org/project/cpplint/"
  url "https://files.pythonhosted.org/packages/c5/0f/4f2de12a37b1cbfefabff29ef8d529336c2ceec3226e270b369e8e52c735/cpplint-1.6.0.tar.gz"
  sha256 "8af99f95ed1af2d18e60467cdc13ee0441c2a14d693b7d2dbb71ad427074e491"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52d1995aad005c3f5b2bf942e97ae8614aa32b0cdbc42b89366d9bdd02cfdca8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52d1995aad005c3f5b2bf942e97ae8614aa32b0cdbc42b89366d9bdd02cfdca8"
    sha256 cellar: :any_skip_relocation, monterey:       "8f6ae4eafa2e16ecbc84c7f36c9f37376a3e20b4469d3d7a8f53b13e9b9a9d56"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f6ae4eafa2e16ecbc84c7f36c9f37376a3e20b4469d3d7a8f53b13e9b9a9d56"
    sha256 cellar: :any_skip_relocation, catalina:       "8f6ae4eafa2e16ecbc84c7f36c9f37376a3e20b4469d3d7a8f53b13e9b9a9d56"
    sha256 cellar: :any_skip_relocation, mojave:         "8f6ae4eafa2e16ecbc84c7f36c9f37376a3e20b4469d3d7a8f53b13e9b9a9d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f37dd7a7c63a626a990f6703348e9cafec1e4928b3bd4eee470062fc45a77b0e"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources

    # install test data
    pkgshare.install "samples"
  end

  test do
    output = shell_output("#{bin}/cpplint --version")
    assert_match "cpplint #{version}", output.strip

    output = shell_output("#{bin}/cpplint #{pkgshare}/samples/v8-sample/src/interface-descriptors.h", 1)
    assert_match "Total errors found: 2", output
  end
end
