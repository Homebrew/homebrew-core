class FormatUdf < Formula
  desc "Bash script to format a block device to UDF"
  homepage "https://github.com/JElchison/format-udf"
  url "https://github.com/JElchison/format-udf/archive/refs/tags/1.8.0.tar.gz"
  sha256 "52854097db9044d729fbd7cff012f4b554df01c15225ee17ec159c71da174c8d"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "ba8a2952eb6a60e6660c71d6054d6a0adc3d450d5532ef270f2849a0fd13849d"
  end

  def install
    bin.install "format-udf.sh" => "format-udf"
  end

  test do
    system bin/"format-udf", "-h"
  end
end
