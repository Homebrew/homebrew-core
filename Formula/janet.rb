class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.23.0.tar.gz"
  sha256 "0b4d5d3632e0d376d9512ea8ea262f31f75c132b488dd7870f472acae709a865"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9d8b3c4f58edeeaf9edb18136bce805f0013a0e334853a51570551847980fdbb"
    sha256 cellar: :any,                 arm64_big_sur:  "c09ba1d9ebf8d4d0b9711c7c57497284d3a0d0fbab77ca639962d07193bc3142"
    sha256 cellar: :any,                 monterey:       "0e47873696cdefb25e15fd47082135f2cf97d101cd06aa6237369ffc8c3a4734"
    sha256 cellar: :any,                 big_sur:        "8249be1f62d79ebc226c5cde147c3ec2f1b264e429bb806283b8588e92f49808"
    sha256 cellar: :any,                 catalina:       "15e8579d7cba3a789ae7a2388c8c96a2a21e0de6824f7b4190ae7d2cc9f06629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee04cae362695afc923c7dd12e2be88d14ba3f76bb8dc5f38c0afe8cbde1e9f1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  resource "jpm" do
    url "https://github.com/janet-lang/jpm/archive/refs/tags/v1.0.0.tar.gz"
    sha256 "858d4ef2f6ac78222c53154dd91f8fb5994e3c3cbe253c9b0d3b9d52557eeb9b"
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
