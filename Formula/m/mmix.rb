class Mmix < Formula
  desc "64-bit RISC architecture designed by Donald Knuth"
  homepage "https://mmix.cs.hm.edu/"
  url "https://mmix.cs.hm.edu/src/mmix-20160804.tgz"
  sha256 "fad8e64fddf2d75cbcd5080616b47e11a2d292a428cdb0c12e579be680ecdee9"
  license "MMIXware"

  livecheck do
    url "https://mmix.cs.hm.edu/src/"
    regex(/href=.*?mmix[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "7689d31c594d9eedf364554062db949537fddfca38576923554a2fbe0a9f9728"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1c3cedb93df0fcbe150243f8251870245301689823aa1f8275c897961e199a04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45fa11184bd917b9c6fed6910afb1f5b2cf9a92d1bec2a0d821e3b3c68ccb5e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf7b89901297da556ae769c209fae21d23057d4e0277197b3e317efbcef427a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb698eeaba81433e47c44d2eab8858b272c3c711d6b6a745e9a43d7d0c3908c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03a6468d729fc0ccddb6187c50b8f0318dedbe2bf613ef2e86e95aada83daeac"
    sha256 cellar: :any_skip_relocation, sonoma:         "8bc17d38356b5fa43bd4029db34b82fbe6cca469a3d09831a9747b4c945b17d5"
    sha256 cellar: :any_skip_relocation, ventura:        "f246f0fd905410b6c8df7802eaaa0af9bcb7cde18af61a623f4f0b7a18443b8e"
    sha256 cellar: :any_skip_relocation, monterey:       "69c25099d92634bba78ac9ad1565f5af979bd473b14414cf4dd35dc9349c4a76"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa0a9dd7f5ea9520ffd9c4682df2d754462a7b7e6d7b30bc8ea84f39903fa29e"
    sha256 cellar: :any_skip_relocation, catalina:       "ca577c8e313e25ce4b0ccdf1067a9fa1765b23a3f63b26905ad3aea044507ece"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fe0fb42d869faab340474f2d311f80ef4fd40754ecbf9218ff6e76d50d790e03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1095cb1a943d20e2613c77874a67e1f41bc17eeccc3b503cfb5ce3f6215fd01f"
  end

  depends_on "cweb" => :build

  # fix implicit int build error
  # upstream patch ref, https://gitlab.lrz.de/mmix/mmixware/-/commit/c02e7081d033895dfaeb8154ad9bd6f5893487ea
  patch :DATA

  # fix duplicate declaration of buffer
  patch do
    url "https://gitlab.lrz.de/mmix/mmixware/-/commit/2eddd633bc98fd320e317bbcd6c98399250e68ec.diff"
    sha256 "512fc7d27b974bf5a58781464d4dba1c2147142ba749a2eb17c1a7b358ef8db9"
  end

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

__END__
diff --git a/abstime.w b/abstime.w
index 50d6aa9f7585afae69ff22ee9b58a919c2c1db97..6605ba1071995e70b3e435009b52f5f3c2f7ea72 100644
--- a/abstime.w
+++ b/abstime.w
@@ -18,7 +18,7 @@ hold more than 32 bits.
 #include <stdio.h>
 #include <time.h>
 @#
-main()
+int main()
 {
   printf("#define ABSTIME %ld\n",time(NULL));
   return 0;
