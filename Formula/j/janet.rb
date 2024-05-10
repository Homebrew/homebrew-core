class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "d49670c564dcff6f9f7945067fa2acbd3431d923c25fc4ce6e400de28eeb0b1b"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2beb4af6de2fc7879dca0b55a89b65ac85563aae483ecebd250a5df6d9f846c4"
    sha256 cellar: :any,                 arm64_ventura:  "38b64cb9d58bfa6e7a1a533ce2b900bdce5138fb887501918452f4fab15f23c2"
    sha256 cellar: :any,                 arm64_monterey: "3f48aa5a7628dd0bf35cdfa648da93ec9c4b3e39854c0ea722ccc9ea95806696"
    sha256 cellar: :any,                 sonoma:         "9aaa4ace92c9c207011f98e7dd3661c3ea5bcceff249c76b5a226dcf3118de0b"
    sha256 cellar: :any,                 ventura:        "3b1b14ea29f515bc4788b04f0043e57ffa457a195b29a8cec980692bfab49ff1"
    sha256 cellar: :any,                 monterey:       "400bc2eda7c71279ccd466b7acdd34e50e7eba1d20313887c84d4aa6f2d08807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d122b7da9bfd3617463409e0280c7e10abbfa340069cd72d42adc0b5dfb2dbce"
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
