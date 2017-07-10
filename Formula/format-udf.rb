class FormatUdf < Formula
  desc "Bash script to format a block device to UDF"
  homepage "https://github.com/JElchison/format-udf"
  url "https://github.com/JElchison/format-udf/archive/1.5.1.tar.gz"
  sha256 "58644fc128e52c6f886c8852193aef1ee58bfef3a59a1646433c4bfcec0400d8"

  bottle :unneeded

  def install
    bin.install "format-udf.sh" => "format-udf"
  end

  test do
    system "#{bin}/format-udf", "-h"
  end
end
