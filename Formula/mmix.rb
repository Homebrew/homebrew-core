class Mmix < Formula
  desc "64-bit RISC architecture designed by Donald Knuth"
  homepage "http://mmix.cs.hm.edu/"
  url "http://mmix.cs.hm.edu/src/mmix-20131017.tgz"
  sha256 "aa64c4b9dc3cf51f07b330791f8ce542b0ae8a1132e098fa95a19b31350050b4"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "4b475fc20b7db2c181af3fc7d428cee8a84908d561e6c6e465d04be87f720174" => :el_capitan
    sha256 "ee8d4243e19537e2f63583118b1e28cb7f381025ca22ab886c4d9be81ad67687" => :yosemite
    sha256 "03721382856f84325efda7ea173e3489412ab71d98928b50c3400c7a435b227e" => :mavericks
  end

  depends_on "cweb" => :build

  def install
    ENV.deparallelize

    system "make", "all"

    bin.install "mmix", "mmixal", "mmmix", "mmotype"
  end

  test do
    (testpath/"hello.mms").write <<-EOS
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
