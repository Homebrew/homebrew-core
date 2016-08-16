class Jxrlib < Formula
  desc "Tools for JPEG-XR image encoding/decoding"
  homepage "https://jxrlib.codeplex.com/"
  url "https://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=jxrlib&DownloadId=685250&FileTime=130142428056630000&Build=21031"
  version "1.1"
  sha256 "a79e27801ab19af936beb9ece36f1c6c1914c3baf25597fd270709dc4520a190"

  head "https://git01.codeplex.com/jxrlib", :using => :git

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
