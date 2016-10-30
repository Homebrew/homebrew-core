class Jxrlib < Formula
  desc "Tools for JPEG-XR image encoding/decoding"
  homepage "https://jxrlib.codeplex.com/"
  url "https://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=jxrlib&DownloadId=685250&FileTime=130142428056630000&Build=21031"
  version "1.1"
  sha256 "a79e27801ab19af936beb9ece36f1c6c1914c3baf25597fd270709dc4520a190"

  head "https://git01.codeplex.com/jxrlib", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "47c308b47ec8227d813a21c8092b32ada9b7f862aef102bf619d6bb19f0144e1" => :el_capitan
    sha256 "0dae977caf9e34289c9dd09f7e12bdf7158ccc42d9fa2dc00b4164b82c1caf3f" => :yosemite
    sha256 "cc49654146951a561ca6fce7c485f7f3f3511ab5549a7db8263e4e8ddc95e740" => :mavericks
  end

  def install
    if build.head?
      system "make", "install", "DIR_INSTALL=#{prefix}"
    else
      system "make"
      # The current stable release (1.1) doesn't have a make 'install' target
      lib.install %w[libjxrglue.a libjpegxr.a]
      bin.install %w[JxrEncApp JxrDecApp]
      include.install %w[common image]
      include.install "jxrgluelib" => "glue"
      include.install "jxrtestlib" => "test"
      doc.install Dir["doc/*"]
    end
  end

  test do
    bmp = "Qk06AAAAAAAAADYAAAAoAAAAAQAAAAEAAAABABgAAAAAAAQAAADDDgAAww4AAAAAAAAAAAAA////AA==".unpack("m")[0]
    infile  = "test.bmp"
    outfile = "test.jxr"
    File.open(infile, "wb") { |f| f.write bmp }
    system bin/"JxrEncApp", "-i", infile,  "-o", outfile
    system bin/"JxrDecApp", "-i", outfile, "-o", infile
  end
end
