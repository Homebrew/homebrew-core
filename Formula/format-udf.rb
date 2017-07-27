class FormatUdf < Formula
  desc "Bash script to format a block device to UDF"
  homepage "https://github.com/JElchison/format-udf"
  url "https://github.com/JElchison/format-udf/archive/1.6.0.tar.gz"
  sha256 "87af133e41844c95c2fa39988487fee3bccf848716bed32eb0a9d3ca3d20e070"

  bottle :unneeded

  def install
    bin.install "format-udf.sh" => "format-udf"
  end

  test do
    system "#{bin}/format-udf", "-h"
  end
end
