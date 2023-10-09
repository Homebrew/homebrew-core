class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/1d/03/338fba56a6c76ea6d99ca0b7af3098292c2dd6597ed656daa6ae26a07a77/dunamai-1.19.0.tar.gz"
  sha256 "6ad99ae34f7cd290550a2ef1305d2e0292e6e6b5b1b830dfc07ceb7fd35fec09"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23134ecf6ddb25eccee07a2b51e8223826b5000d539c25e4bbbaf11804936f41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebe202fa284a2efaeb365cf9bfe3bb0ebe1b70876d3adbf994af3ab11848e137"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57df59a50346a2f330055a2a110c1c3238b9415649efab5aba639de687d9d01d"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9a68b63346282df79d202d7dba6b86f1243ae1d0bb242d566e0630d6beadf80"
    sha256 cellar: :any_skip_relocation, ventura:        "9449c31b2200dc0ef391a64b9e9514af9dd81e37b571a63c846b45dd64a34a65"
    sha256 cellar: :any_skip_relocation, monterey:       "c92958c2a64a4d6f88ed34e7d12db8d8888586e9993732495e46b99767b4b33c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c7ce7a5209524f43bd013b76f27f1bb8372e15186f4ce58a46aa7c369bc3246"
  end

  depends_on "python-packaging"
  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"
    system "git", "tag", "v0.1"
    assert_equal "0.1", shell_output("#{bin}/dunamai from any").chomp
  end
end
