class Lorem < Formula
  include Language::Python::Shebang

  desc "Python generator for the console"
  homepage "https://github.com/per9000/lorem"
  url "https://github.com/per9000/lorem/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "3eec439d616a044e61a6733730b1fc009972466f869dae358991f95abd57e8b3"
  license "GPL-3.0-or-later"
  head "https://github.com/per9000/lorem.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "8b19f09aa8ff1a1e6e6dae8a356ac8ae90992a3435540b0fd71b7d39a7d3f360"
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
