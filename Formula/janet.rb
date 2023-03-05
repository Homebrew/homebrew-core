class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.27.0.tar.gz"
  sha256 "a81c8750844323eb73aea064db9c467aa3361a03fc6f251d3e19a473b147082d"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8591e026b8ddcdd60ec1ed7b137a35c754a999aa132fc4ced5d1a123e0a55358"
    sha256 cellar: :any,                 arm64_monterey: "21b27e7772c20f79e4eafdb7ca903e3612a1d159f5afb80eaff00bb7727dcffe"
    sha256 cellar: :any,                 arm64_big_sur:  "cf893250e477217141108cf83ee14c3eb211a14db3afd4661c870446e498685d"
    sha256 cellar: :any,                 ventura:        "5af21acaa282b5e5f653e3d9f0413e401bf008348506ae38cd52f9828dc292c8"
    sha256 cellar: :any,                 monterey:       "d8b3b170c5ac12f9d679300105187e7a8a43767fe2f7a74f11ba2fc7244b8026"
    sha256 cellar: :any,                 big_sur:        "26197e7a61a2210fbe87401a8352c9c744aebda9204e573feb2f0624c492b803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af9fae81017a821cad8f02efc6cf96758c842a12893fb440513b68eb0ac7f2a2"
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
