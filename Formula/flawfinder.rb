class Flawfinder < Formula
  include Language::Python::Shebang

  desc "Examines code and reports possible security weaknesses"
  homepage "https://www.dwheeler.com/flawfinder/"
  url "https://www.dwheeler.com/flawfinder/flawfinder-2.0.15.tar.gz"
  sha256 "0a65cf93b1d380669476e576abbb04ea0766a557ce2bf75d9e71f387fcd74406"
  license "GPL-2.0"
  head "https://github.com/david-a-wheeler/flawfinder.git"

  livecheck do
    url :homepage
    regex(/href=.*?flawfinder[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "79d63099bc5b10544dd3a42ea7f2b71247ed13569846917537bd992241051fed" => :big_sur
    sha256 "4591261ed40fdb45d6a4bdaa3f796633d3f9ae862ffe3db1f77a0162cd4042ac" => :arm64_big_sur
    sha256 "c4b2f7f2353d8d032e0e1f352860f69c23c21092dc718f4d4832bc1dbe20a2f1" => :catalina
    sha256 "ba1a903081761bfb7ba492ac5fc84300da3ffc20819ed240a6854c3441b69eff" => :mojave
    sha256 "38fc9609b4526463f7d4d3d4dd1377fb979a64208562de1a5d4d6f1ff9237c67" => :high_sierra
  end

  depends_on "python@3.9"

  resource "flaws" do
    url "https://www.dwheeler.com/flawfinder/test.c"
    sha256 "4a9687a091b87eed864d3e35a864146a85a3467eb2ae0800a72e330496f0aec3"
  end

  def install
    rewrite_shebang detected_python_shebang, "flawfinder"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    resource("flaws").stage do
      assert_match "Hits = 36",
                   shell_output("#{bin}/flawfinder test.c")
    end
  end
end
