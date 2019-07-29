class FormatUdf < Formula
  desc "Bash script to format a block device to UDF"
  homepage "https://github.com/JElchison/format-udf"
  url "https://github.com/JElchison/format-udf/archive/1.6.1.tar.gz"
  sha256 "c87e2690986c5f98991937b31824f8e227ce703b17a7ca0fe63f7e6594ae9ae0"

  bottle :unneeded

  def install
    bin.install "format-udf.sh" => "format-udf"
  end

  test do
    system "#{bin}/format-udf", "-h"
  end
end
