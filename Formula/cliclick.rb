class Cliclick < Formula
  desc "Tool for emulating mouse and keyboard events"
  homepage "https://www.bluem.net/jump/cliclick/"
  url "https://github.com/BlueM/cliclick/archive/5.0.tar.gz"
  sha256 "b013314702932c5cc3bf7d54d3966afb2ed6331c66e3d11235e8ea83c695e051"
  license "BSD-3-Clause"
  head "https://github.com/BlueM/cliclick.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b69ae3c108b346648be43b6a4c20278a4ee2964351e43f677079757343aa23d2"
    sha256 cellar: :any_skip_relocation, big_sur:       "7e6bcf10902d1e4b2da9d1b8a4bd3999ab5fe6257ee67175f9e124d479fedb0b"
    sha256 cellar: :any_skip_relocation, catalina:      "4cc28069cf249576d31df617e2be6be38dacb9896f21967d7ad3797e9d65a87c"
    sha256 cellar: :any_skip_relocation, mojave:        "7ff1aa3722085a9bbcdbd3fe496a84dcef9774a75b0374c0c3f404517aa79eca"
  end

  def install
    system "make"
    bin.install "cliclick"
  end

  test do
    system bin/"cliclick", "p:OK"
  end
end
