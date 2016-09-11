class FormatUdf < Formula
  desc "Bash script to format a block device to UDF"
  homepage "https://github.com/JElchison/format-udf"
  url "https://github.com/JElchison/format-udf/archive/1.4.1.tar.gz"
  sha256 "ed17380185e7fe7f08ac5ad9c6c2bcf63026b924ca57fc8ab5ac1a36bb45a992"

  bottle :unneeded

  def install
    bin.install "format-udf.sh" => "format-udf"
  end

  test do
    system "#{bin}/format-udf", "-h"
  end
end
