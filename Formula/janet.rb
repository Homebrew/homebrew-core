class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.15.3.tar.gz"
  sha256 "a92d8540f422eb690fa1634e01cd18b4a2a3d184f7d3f219bf4a77c3a655baae"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "28ad90a61f41574feeaf505fd3d2450a401378fcd804fb860c6afc149fe7a3de"
    sha256 cellar: :any, big_sur:       "a7ea52421f80715a4f336dafffa32e06a832e416497b1e2d95c571db24321e46"
    sha256 cellar: :any, catalina:      "ce9031826ba001b9df87b61f7479cf489b389fd273f0d7a66f4e799d2a6f8ef2"
    sha256 cellar: :any, mojave:        "55402ae8e9b08161838de5545b86f354f2d8f48b5f42b77848a0f65785b5742d"
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
