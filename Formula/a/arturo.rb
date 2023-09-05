class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "https://arturo-lang.io/"
  url "https://github.com/arturo-lang/arturo/archive/refs/tags/v0.9.83.tar.gz"
  sha256 "0bb3632f21a1556167fdcb82170c29665350beb44f15b4666b4e22a23c2063cf"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "701164bed099b947aa49f4a43859d67c0a74d1f3bf2082f467a7da1538424cf3"
    sha256 cellar: :any,                 arm64_monterey: "10f339f02e6380d50b60a189badac2df81c704df5ddd460e74b3ff1b373f5882"
    sha256 cellar: :any,                 arm64_big_sur:  "b10aa1682766a87b5e59f4b325c79a1d1d92581cd233e5d9c8aaa92f776b4f52"
    sha256 cellar: :any,                 ventura:        "ac693db23392af435651910c80e9ab061fa25d2ee89407e01e6306d8b0ca888d"
    sha256 cellar: :any,                 monterey:       "6dc64bc30895c26e36f84857596a2429f3a3f4d8813e34390da09b97ac7d6d23"
    sha256 cellar: :any,                 big_sur:        "bafd65e868556efe9167913ba7274a91b06b44b4dc33ecd7ce06c74781ca6eda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53abb703d9ef8eb1301fc054b851b564b4133f4936b63ddf23805c120fa5cdc5"
  end

  depends_on "nim" => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "mysql"

  def install
    inreplace "build.nims", /ROOT_DIR\s*=\s*r"\{getHomeDir\(\)\}.arturo".fmt/, "ROOT_DIR=\"#{prefix}\""

    # Work around issues with Xcode 14.3
    # @mhelpers@swebviews.nim.c:1116:2: error: call to undeclared function 'generateDefaultMainMenu';
    # ISO C99 and later do not support implicit function declarations
    inreplace "build.nims", "--passC:'-flto'", "--passC:'-flto' --passC:'-Wno-implicit-function-declaration'"

    # Use mini install on Linux to avoid webkit2gtk dependency, which does not have a formula.
    args = ["log", "release"]
    args << "mini" if OS.linux?
    system "./build.nims", "install", *args
  end

  test do
    (testpath/"hello.art").write <<~EOS
      print "hello"
    EOS
    assert_equal "hello", shell_output("#{bin}/arturo #{testpath}/hello.art").chomp
  end
end
