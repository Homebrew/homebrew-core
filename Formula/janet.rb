class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.30.0.tar.gz"
  sha256 "64a8a923f5c5065047c91cce9c27ed0a60899ad5810b2c6f590bc5e24a4e834b"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "85238a0eebe12cb132e6385b907b0f9c895f855df7adfd25aadbcdff416842f6"
    sha256 cellar: :any,                 arm64_monterey: "9c964283f3e45c25f67dbc39f09c2526a73341f1420f942332ab22cd46c81e77"
    sha256 cellar: :any,                 arm64_big_sur:  "09a906e24ff2419a85829415d6e1da77afd5b547cf3a086348f66d17548f6886"
    sha256 cellar: :any,                 ventura:        "2b9bcec0aef6f6523eea4d0ed272647cf82b9fe4a46e8536fc68d91f1cca2671"
    sha256 cellar: :any,                 monterey:       "31146e83d552743d3de9bdd30ebac4d7d3af0fa1971159b2da53c45e911d64d2"
    sha256 cellar: :any,                 big_sur:        "be180d693876cac89076bce8397dafaab516f9299372c44765e4481fd02e1b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91929ac01087561ba5590bfa41e7ee49fa430d431d1678025bd801e204257acb"
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
