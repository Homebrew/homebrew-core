class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "https://arturo-lang.io/"
  url "https://github.com/arturo-lang/arturo/archive/refs/tags/v0.9.83.tar.gz"
  sha256 "0bb3632f21a1556167fdcb82170c29665350beb44f15b4666b4e22a23c2063cf"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "a5ec87e6b0b78f8f9c7488ee60fba66fa32b820ad0beb17a2a2ad609cf0db4ef"
    sha256 cellar: :any,                 arm64_ventura:  "18491874794e510a5ceab9f85b056dd5338869c63d6590bd8d2e5e5eb451e081"
    sha256 cellar: :any,                 arm64_monterey: "97ada88c358d6b8fee6731bc2fb5a2b6f869ff0d9798b831801aa16096db0e40"
    sha256 cellar: :any,                 sonoma:         "080ae8f329e1f5434ff565a2731066510251e94be46b3dbc88ce81d7fa131395"
    sha256 cellar: :any,                 ventura:        "bfd55cd5a7c527f3ee97be03d31019f19bcc42e8827eff660a3e0225fc010601"
    sha256 cellar: :any,                 monterey:       "a131b4cca2eb06a0077955ad754e0cf2e028b6edcb8d59f671d3863f4d0c9e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58f4a8c2fa4c22f00887c45852b4fe5326d1df941f484f5884bf5cab6df1c81a"
  end

  depends_on "gmp"
  depends_on "mpfr"

  # TODO: switch to `depends_on "nim" => :build` in the next release
  resource "nim" do
    url "https://nim-lang.org/download/nim-1.6.14.tar.xz"
    sha256 "d070d2f28ae2400df7fe4a49eceb9f45cd539906b107481856a0af7a8fa82dc9"
  end

  def install
    (buildpath/"nim").install resource("nim")
    cd "nim" do
      system "./build.sh"
      system "./bin/nim", "c", "-d:release", "koch"
      system "./koch", "boot", "-d:release", "-d:useLinenoise"
    end
    ENV.prepend_path "PATH", buildpath/"nim/bin"

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
