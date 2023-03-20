class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.27.0.tar.gz"
  sha256 "a81c8750844323eb73aea064db9c467aa3361a03fc6f251d3e19a473b147082d"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6051ac5748ae7cb8ac3d726d78078dd688099f2146f35cd3871e82d57e9b30da"
    sha256 cellar: :any,                 arm64_monterey: "329a4a3a4319fc5572eb4d7bb26775b478eef7be968df9d74bd963d2c9554edc"
    sha256 cellar: :any,                 arm64_big_sur:  "8cee310e2cfb83c03673dc33a8e7810caeb62491bb076aede2362b4378a4ccd4"
    sha256 cellar: :any,                 ventura:        "a399e413ec85dbf86f8e5dfd7a93743a53093353ffd5873db63e083975c9bba0"
    sha256 cellar: :any,                 monterey:       "55208cdfa086af3cb91fbed30334008de3e975657ca94723bd9584adf5c517fc"
    sha256 cellar: :any,                 big_sur:        "95e33b6c8107652ad2e2b28d15ac48646fc8ab9bda2a0280efc3752e78695eb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a092b0e7fadd4031b2716118d84940d6d0621449aea0e8d91f777be411af8a2"
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
