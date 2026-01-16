class Csmith < Formula
  desc "Generates random C programs conforming to the C99 standard"
  homepage "https://github.com/csmith-project/csmith"
  url "https://github.com/csmith-project/csmith/archive/refs/tags/csmith-2.3.0.tar.gz"
  sha256 "9d024a6b202f6a1b9e01351218a85888c06b67b837fe4c6f8ef5bd522fae098c"
  license "BSD-2-Clause"
  head "https://github.com/csmith-project/csmith.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:csmith[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "5dd099418eb9b36019dfabac7bad13d6d2c0eb6d01700c57fbb6323b6c8331d2"
    sha256 cellar: :any,                 arm64_sequoia:  "8da68f418cb134b12223efaea3b1a32c75d51a975458ec0b95ea5cfb90b2810a"
    sha256 cellar: :any,                 arm64_sonoma:   "52a3fef01ef8a1161d9695787c592c17d405fba995615a6420d5723b8fd49e09"
    sha256 cellar: :any,                 arm64_ventura:  "289f49509657abe2bebc5f5b18f95df1c27860bb9cb9cfb6c5b740bb7ee77010"
    sha256 cellar: :any,                 arm64_monterey: "27b069ffcef5994e076353234fed07390d0a2462abc2b851669f619f30f6881c"
    sha256 cellar: :any,                 arm64_big_sur:  "79b39e5332514e816d46c871b31a283e9d16adc4d39f2b5177c3569ce2508c4a"
    sha256 cellar: :any,                 sonoma:         "d848b6c49abb0999c8ab6da4ee3ed292cd014338ad26bc5a1e007f58f7cefb03"
    sha256 cellar: :any,                 ventura:        "4e49e28ba325a522c1fc7581bb550bad3d7e411aad88b2eb13e64e049bfb44fc"
    sha256 cellar: :any,                 monterey:       "2ea649dec15e5b7387bde10f8c564c168455ab7b0bca454e669aba28413b10d6"
    sha256 cellar: :any,                 big_sur:        "1194af6247da39f02e322f002dacb9654fb1b614a77ecab2a384bb8715493d01"
    sha256 cellar: :any,                 catalina:       "fdce1186c77ea774ed5575cd59bc194ab35725d3117c9a57bd54ce351a620965"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7dcd32413bf5de8028c02d4e648fca8799aa716f58ae19a7df00eada072888da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "527b8e04eb83e46dd0a24ea321f71bed291f11a158338c1106241365ba3a849b"
  end

  uses_from_macos "m4" => :build

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Workaround for newer Clang until upstream fix
    # https://github.com/csmith-project/csmith/issues/163
    # https://github.com/csmith-project/csmith/issues/177
    # https://github.com/csmith-project/csmith/pull/165
    ENV.append_to_cflags "-Wno-enum-constexpr-conversion" if DevelopmentTools.clang_build_version >= 1700

    system "./configure", *std_configure_args
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
    system bin/"csmith", "-o", "test.c"
  end
end
