class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.26.0.tar.gz"
  sha256 "c95dab93e8e4ebcab5c293d5ee448fb43ab8bd2f6391fd66a6ca92fe1ec72c03"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c6deaf13e3401ec0b929324224b04e94948c0b219855997652a690a4e1d190bf"
    sha256 cellar: :any,                 arm64_monterey: "da6a5175726641da200ca353bc3b3cb0311161b61f17918177396e3eca1ef30c"
    sha256 cellar: :any,                 arm64_big_sur:  "e74fe5fbaa37a6a3fd1972daea26cf783aff534e249d4f7cdac49aacd3b59f87"
    sha256 cellar: :any,                 ventura:        "3b9a6cda60e70eac143ade05592ad4e1f24a007a015e9d8afa1dfd5e46ec34e0"
    sha256 cellar: :any,                 monterey:       "5e99427c6720819e26fff4c0e6353348499bdf9f762cae9e033e9dd70b5be197"
    sha256 cellar: :any,                 big_sur:        "469af239c98f99bc0b38a2fbb09e6ccc9c585874f27a329debea283945c24ab8"
    sha256 cellar: :any,                 catalina:       "52801cff99c35dfa418cf4acb6030c8d486bdedcc4bea49a3b98e9fc2ac7aa61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c654c3f46a43de2034bdf19ee183c4262005b163cf4ba143da145465d54c3564"
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
