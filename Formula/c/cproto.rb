class Cproto < Formula
  desc "Generate function prototypes for functions in input files"
  homepage "https://invisible-island.net/cproto/"
  url "https://invisible-mirror.net/archives/cproto/cproto-4.8a.tgz"
  mirror "https://deb.debian.org/debian/pool/main/c/cproto/cproto_4.8a.orig.tar.gz"
  sha256 "beb121e08c0d47b5bd719071c32a77edcc31dff992a84e3d9a59c0f7ec9fadd3"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/cproto/"
    regex(/href=.*?cproto[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ba9c248c0887cccb3f81057bfcef8a05862b5627574f31f545d0a27c8dd7160"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8ffd686ae41ff4ef3cb88d648f6a59c6a92243912632efa2827b1fdb9651fe5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "456abbd2e8d94552d991bff61a63b393b791b2126d6922626fd7c5a522467330"
    sha256 cellar: :any_skip_relocation, sonoma:        "35be189aefe776a96712046ef54fc40a363882e37be99f9941af850f26dcbc8e"
    sha256 cellar: :any,                 arm64_linux:   "c7f372dc2d217837cfe6c634387cb289e7c5c317be55928fd72c9237260230d8"
    sha256 cellar: :any,                 x86_64_linux:  "046a3ba0b1788b53bd5a00fca53c305333a22dfbef862702350dad749d3014b1"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"woot.c").write("int woot() {\n}")
    assert_match(/int woot.void.;/, shell_output("#{bin}/cproto woot.c"))
  end
end
