class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.32.1.tar.gz"
  sha256 "ac74444f1b545830c34738fe9ebb58c865ea4b819b0b0c3124315c646d9ce4cb"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "624cbfb4dafbb08f23bb449d8bd8a5d136227a300bafaa521c217af2f29f958d"
    sha256 cellar: :any,                 arm64_ventura:  "b2edd659bfd06f71e647f119f931d47ad975d216237117182673bda957152733"
    sha256 cellar: :any,                 arm64_monterey: "144b3949f59732ac7f925f4b5fb15b21c0249d877038123f300c5554a282636f"
    sha256 cellar: :any,                 sonoma:         "ada9508c4b53d3f32b1ae042d8911aed69a22fe7176d122d50ae4f8e14ed1011"
    sha256 cellar: :any,                 ventura:        "ff73769a3155bf38baf72ad317d2e64daace7a2eaa66565aed5aeb4efbc50b90"
    sha256 cellar: :any,                 monterey:       "f6c99c3b75c0e797e40817ff26637823c3fed6a698300ebb52bcb4376cec42b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78e1de2388b03c24c37c0bd925972179227f87805727f8339048b160bb5ee09a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  resource "jpm" do
    url "https://github.com/janet-lang/jpm/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "337c40d9b8c087b920202287b375c2962447218e8e127ce3a5a12e6e47ac6f16"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
    ENV["PREFIX"] = prefix
    resource("jpm").stage do
      system bin/"janet", "bootstrap.janet"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
    assert_predicate HOMEBREW_PREFIX/"bin/jpm", :exist?, "jpm must exist"
    assert_predicate HOMEBREW_PREFIX/"bin/jpm", :executable?, "jpm must be executable"
    assert_match prefix.to_s, shell_output("#{bin}/jpm show-paths")
  end
end
