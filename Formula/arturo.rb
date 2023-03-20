class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "https://arturo-lang.io/"
  url "https://github.com/arturo-lang/arturo/archive/refs/tags/v0.9.83.tar.gz"
  sha256 "0bb3632f21a1556167fdcb82170c29665350beb44f15b4666b4e22a23c2063cf"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9764085cbe25c95d32bc664488a5a32cf96d084a2297795a41f5f48d00de26d8"
    sha256 cellar: :any,                 arm64_monterey: "677bc52f00e1f29785f398322ef1e626937f72448cafe04be89d5c70a7c08c94"
    sha256 cellar: :any,                 arm64_big_sur:  "e789724da912ae762ce8d024b1b67b5b970b6633ee65faa104a1978bfc5b611b"
    sha256 cellar: :any,                 ventura:        "19d0bf41aa2c91c201cace61f3fa3a45b697a35f0f8502058c0984e44eab7414"
    sha256 cellar: :any,                 monterey:       "d308d8d2af2118bcfdb6a7f6a10bd2185ea460ca3ab7e5c45ac5abca4763df0a"
    sha256 cellar: :any,                 big_sur:        "0b89382b8412200743a13775357656b8a20ca1944fee7e83fa6983ebe30fb5f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac7789d3c4ecc404a4e86e5c216c2bab553a8521642fdcdf69b8bc52fadf426b"
  end

  depends_on "nim" => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "mysql"

  def install
    inreplace "build.nims", /ROOT_DIR\s*=\s*r"\{getHomeDir\(\)\}.arturo".fmt/, "ROOT_DIR=\"#{prefix}\""
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
