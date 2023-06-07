class Csmith < Formula
  desc "Generates random C programs conforming to the C99 standard"
  homepage "https://embed.cs.utah.edu/csmith/"
  url "https://embed.cs.utah.edu/csmith/csmith-2.3.0.tar.gz"
  sha256 "f247cc0aede5f8a0746271b40a5092b5b5a2d034e5e8f7a836c879dde3fb65d5"
  license "BSD-2-Clause"
  head "https://github.com/csmith-project/csmith.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?csmith[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "289f49509657abe2bebc5f5b18f95df1c27860bb9cb9cfb6c5b740bb7ee77010"
    sha256 cellar: :any,                 arm64_monterey: "27b069ffcef5994e076353234fed07390d0a2462abc2b851669f619f30f6881c"
    sha256 cellar: :any,                 arm64_big_sur:  "79b39e5332514e816d46c871b31a283e9d16adc4d39f2b5177c3569ce2508c4a"
    sha256 cellar: :any,                 ventura:        "4e49e28ba325a522c1fc7581bb550bad3d7e411aad88b2eb13e64e049bfb44fc"
    sha256 cellar: :any,                 monterey:       "2ea649dec15e5b7387bde10f8c564c168455ab7b0bca454e669aba28413b10d6"
    sha256 cellar: :any,                 big_sur:        "1194af6247da39f02e322f002dacb9654fb1b614a77ecab2a384bb8715493d01"
    sha256 cellar: :any,                 catalina:       "fdce1186c77ea774ed5575cd59bc194ab35725d3117c9a57bd54ce351a620965"
    sha256 cellar: :any,                 mojave:         "7c3759ccefa73b295acd5e7e631c40594f6983e26e903b54a88a9e0dfdfcaa96"
    sha256 cellar: :any,                 high_sierra:    "e8e818a9898b4145c5622810958fa8616f8b57156f09aeaf3045873210f0856a"
    sha256 cellar: :any,                 sierra:         "2e78da57153124cb3feca12955d0bbadbc4e90dbff6c34a08532aea55c75ba8e"
    sha256 cellar: :any,                 el_capitan:     "472992fd577ec20b025397c840823abf8f88d719e7d86bba427446a38cc5584d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "527b8e04eb83e46dd0a24ea321f71bed291f11a158338c1106241365ba3a849b"
  end

  uses_from_macos "m4" => :build

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    mv "#{bin}/compiler_test.in", share
    (include/"csmith-#{version}/runtime").install Dir["runtime/*.h"]
  end

  def caveats
    <<~EOS
      It is recommended that you set the environment variable 'CSMITH_PATH' to
        #{include}/csmith-#{version}
    EOS
  end

  test do
    system "#{bin}/csmith", "-o", "test.c"
  end
end
