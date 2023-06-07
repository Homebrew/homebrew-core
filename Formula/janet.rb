class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.28.0.tar.gz"
  sha256 "d78a4c367f1b2c9f95897fa13fc788b36ce49cfcc18083b0810e86b2dd1285bb"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0f35915d5eb7725572b2620a82e6bed64ce46adc9313580cfa40aac85705432b"
    sha256 cellar: :any,                 arm64_monterey: "34069ccaacaa9269b619cdf7a28d772fc45e2094fdc0594fc0a3484f02cec320"
    sha256 cellar: :any,                 arm64_big_sur:  "95e3de956a2faa0def45d11e2b20bef42d8d9daa0aa3bacf765ee80cb6a630e2"
    sha256 cellar: :any,                 ventura:        "e4c212e67a9c606e64c98dfacf8605b25caa10c526ba03e8349cd78e123eb3ac"
    sha256 cellar: :any,                 monterey:       "a4beb1a9caab3380f7eca07432c52136c860c6826a1d3db7d778bf8f489bf727"
    sha256 cellar: :any,                 big_sur:        "64ac1bb0845b0415304cb6b7a9d1bd2b192b682e7cdb5b02a782b3f27d7836ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3a91618b0db044d864a6819f7a44a34d2e013a9b0d2137384dc26bf78cf5128"
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
