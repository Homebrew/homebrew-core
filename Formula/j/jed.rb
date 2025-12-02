class Jed < Formula
  desc "Powerful editor for programmers"
  homepage "https://www.jedsoft.org/jed/"
  url "https://www.jedsoft.org/releases/jed/jed-0.99-19.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/j/jed/jed_0.99.19.orig.tar.gz"
  sha256 "5eed5fede7a95f18b33b7b32cb71be9d509c6babc1483dd5c58b1a169f2bdf52"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.jedsoft.org/releases/jed/"
    regex(/href=.*?jed.?v?(\d+(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:    "6551a5b3bdfe80b3b1446fbf84950d6c14a9b08c511c08af2424b4722821cf78"
    sha256 arm64_sequoia:  "fb9ec5628c166beb0d57337b4c0fb126d53b57b2dd310f81dd8fb5e78d231c93"
    sha256 arm64_sonoma:   "17269b0bce430a0b636c27b6be4ecd349864794d546352a714d2862b5c56bb1f"
    sha256 arm64_ventura:  "bea3094bb9b2ba88a2b58c29c3b230674187d3b9ac0dbaf86b38495da3b69b2c"
    sha256 arm64_monterey: "1ffc68641f689cad733309255377425ffc6acf28d2bafa65dd6cd725489d52e2"
    sha256 arm64_big_sur:  "0705ef662941dc6f4ebd34eae2fc7c02f640d34ac7edbd53eb1d51384cb7c204"
    sha256 sonoma:         "184b189be42a01585cba0885dbe541ab9addae589b5e9cf42e19bb05b143dbf3"
    sha256 ventura:        "cf04039833c1a2f231bf358772e699682547a0193098afd88d32c9a270cd5ffa"
    sha256 monterey:       "c40801b7807e578cad490de05853fcd73cbb1b5c2a762d6948d99e99fb5d4797"
    sha256 big_sur:        "9ed592a6977c9df053eb31b380d31d32af3d3963c005e4feadb5402208193bf8"
    sha256 catalina:       "1b349ce808e1a1a0d2ce8327ef3a68f3ea7678af0bef98c499bbb8d0db9c9a7f"
    sha256 arm64_linux:    "a38ab025d8320824a54a21c5c2c7819ddc29f81f6b5b6e60603cfccd279fa635"
    sha256 x86_64_linux:   "4f1c9d8427fbce7053ed60f13fdcaa4b2dcde1398595d37cfc2fcce4a16669dc"
  end

  head do
    url "git://git.jedsoft.org/git/jed.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "s-lang"

  def install
    args = ["--with-slang=#{Formula["s-lang"].opt_prefix}"]

    if build.head?
      cd "autoconf" do
        system "make"
      end
    elsif OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      # Help old config scripts identify arm64 linux
      args << "--build=aarch64-unknown-linux-gnu"
    end
    system "./configure", *args, *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.sl").write "flush (\"Hello, world!\");"
    assert_equal "Hello, world!",
                 shell_output("#{bin}/jed -script test.sl").chomp
  end
end
