class Mmix < Formula
  desc "64-bit RISC architecture designed by Donald Knuth"
  homepage "http://mmix.cs.hm.edu/"
  url "http://mmix.cs.hm.edu/src/mmix-20160804.tgz"
  sha256 "fad8e64fddf2d75cbcd5080616b47e11a2d292a428cdb0c12e579be680ecdee9"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca577c8e313e25ce4b0ccdf1067a9fa1765b23a3f63b26905ad3aea044507ece" => :catalina
    sha256 "8b1cc6672a548ea1c3320ac4889e6b081792c3181fd4ecfc126ebe9c2fb18365" => :mojave
    sha256 "7bc054e2d244fe693b4ed5ef47c56e23ac4952b15ddc5de55d19150d4dc2bf30" => :high_sierra
    sha256 "b694920e61edf2dec094618910be78fcd4fbbcad22d4d37363555aad38ee0af0" => :sierra
    sha256 "c1e8e0d2d627b3ab2c2c68a8b358981dab07466c3c70f3a2e4df8557006deb92" => :el_capitan
    sha256 "7675c2bc1253e4da2a126d52942449f71cabdd83c39874403d449b5a05ceb145" => :yosemite
  end

  depends_on "cweb" => :build

  def install
    ENV.deparallelize
    system "make", "all"
    bin.install "mmix", "mmixal", "mmmix", "mmotype"
  end

  test do
    (testpath/"hello.mms").write <<~EOS
            LOC  Data_Segment
            GREG @
      txt   BYTE "Hello world!",0

            LOC #100

      Main  LDA $255,txt
            TRAP 0,Fputs,StdOut
            TRAP 0,Fputs,StdErr
            TRAP 0,Halt,0
    EOS
    system bin/"mmixal", "hello.mms"
    assert_equal "Hello world!", shell_output("#{bin}/mmix hello.mmo")
  end
end
