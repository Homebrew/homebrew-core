class Lorem < Formula
  include Language::Python::Shebang

  desc "Python generator for the console"
  homepage "https://github.com/per9000/lorem"
  url "https://github.com/per9000/lorem/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "3eec439d616a044e61a6733730b1fc009972466f869dae358991f95abd57e8b3"
  license "GPL-3.0-or-later"
  head "https://github.com/per9000/lorem.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7098a9c20c1d9eab6b7b903576e883aac9f1baeb5b3a635da1cab28cb9a705a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7098a9c20c1d9eab6b7b903576e883aac9f1baeb5b3a635da1cab28cb9a705a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7098a9c20c1d9eab6b7b903576e883aac9f1baeb5b3a635da1cab28cb9a705a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "7098a9c20c1d9eab6b7b903576e883aac9f1baeb5b3a635da1cab28cb9a705a6"
    sha256 cellar: :any_skip_relocation, ventura:        "7098a9c20c1d9eab6b7b903576e883aac9f1baeb5b3a635da1cab28cb9a705a6"
    sha256 cellar: :any_skip_relocation, monterey:       "7098a9c20c1d9eab6b7b903576e883aac9f1baeb5b3a635da1cab28cb9a705a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6909c7b12382f37766ef98a96e0fc49c73e3142b0e92e5417d9f8de65f3f06e8"
  end

  uses_from_macos "python"

  def install
    bin.install "lorem"
    rewrite_shebang detected_python_shebang(use_python_from_path: true), bin/"lorem"
  end

  test do
    assert_equal "lorem ipsum", shell_output("#{bin}/lorem -n 2").strip.downcase
  end
end
