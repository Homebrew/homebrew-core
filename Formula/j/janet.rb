class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/refs/tags/v1.35.2.tar.gz"
  sha256 "a0e8d56c6025988c8432353e7d67f2c2eb66404d233e6e8113430085dcb4f754"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a2cedfa198a8e5ad0976b83c11acd9dde46605f9da38c9d3761a7881102ab52f"
    sha256 cellar: :any,                 arm64_ventura:  "8f534c42ecc6d7d7ed67a49bae596d48bbcad20878fa1ea6a71212d8f09e5d76"
    sha256 cellar: :any,                 arm64_monterey: "a1fbd797fd966bbe6a4f3180a80c7e2898e007734abfc530cf6be0b6e844f658"
    sha256 cellar: :any,                 sonoma:         "a49bb5ab35ff881e0d421509558d4d517065f13f919f3f1b587c6926b259569c"
    sha256 cellar: :any,                 ventura:        "cf722177e7c3cbf10872947baf38e3d173caf872ee96810cbf186de995800a30"
    sha256 cellar: :any,                 monterey:       "4cb6f719857d5ab6d40d50bfe3e8027a2e7b08e510f06d0b315929ba80fa30cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c3c057859165d7f56a4df04314eaaecc818ff6e6df2f7cc3520ce8d42066492"
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
