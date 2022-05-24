class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.22.0.tar.gz"
  sha256 "7c6969f8e82badc7afa28aa1054555c1c91d2858f9f45c41a82557f5c5ce85bd"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bf9e4c6bede61e305a36f78202d7e371892028aa91a0dfa6c02cf2f4725eb211"
    sha256 cellar: :any,                 arm64_big_sur:  "62b7e8808167d0326a481f65788a5596d199a1ae4537431e14a2a5eb29e0914a"
    sha256 cellar: :any,                 monterey:       "ed969cbfd0a1ed33e5bfeac6696ad1e20b047e220d1a77160dcfb500a68282e9"
    sha256 cellar: :any,                 big_sur:        "50bc3a803726c317dbcc92fdb3f27c71a31ffeb2f01f4da56449f25058813871"
    sha256 cellar: :any,                 catalina:       "e9d4b8d8a50e2c8bffb79e6feb36e52809ebb3407a19a36ad0d08009be8c4a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e561715c89e38aa649546b7851ec93ed8e6a21fc047f137c821af47834dfcae"
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
