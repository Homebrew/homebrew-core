class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.16.0.tar.gz"
  sha256 "84f83b356055557d668dd328a4242bbc652d3cb39e8431666ce391248f4c20e4"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d682c25220432b985321957187aef8e82bbb0145d714f2cde0625a1061fb52a8"
    sha256 cellar: :any, big_sur:       "b7cd8f0613038833ed46f89624a9ac9cce629b347fa2379048610ce2e47a4191"
    sha256 cellar: :any, catalina:      "f33ba7301c9413bfd518989f0ad443caf1707c29ccfd3238d96afabf4b412a0b"
    sha256 cellar: :any, mojave:        "691ede962692477ec037cef8fcdc42414e94dedd78eb4b0f63c684b03b64dbc2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
  end
end
