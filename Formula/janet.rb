class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.11.0.tar.gz"
  sha256 "da5019bbaa5e7964518e576df43a46ac0a0cd2b27b5aeaf3ece95746c8e34678"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "0fc6ab9e55ee6cc6cb1fe4f17f4c10d010e99faa79bf24628e05b63031b5ba93" => :catalina
    sha256 "991ec3cf8e7e8d7ef2a0391816820b8e41dd67f76eb656a79b7adbc3dc1fe055" => :mojave
    sha256 "7e0ee918f6df0c842fd09a41fb7a25e4f75dec32520f68e226f11c7e447c099b" => :high_sierra
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
