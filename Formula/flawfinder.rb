class Flawfinder < Formula
  include Language::Python::Shebang

  desc "Examines code and reports possible security weaknesses"
  homepage "https://www.dwheeler.com/flawfinder/"
  url "https://www.dwheeler.com/flawfinder/flawfinder-2.0.11.tar.gz"
  sha256 "9b4929fca5c6703880d95f201e470b7f19262ff63e991b3ac4ea3257f712f5ec"
  license "GPL-2.0"
  revision 1
  head "https://github.com/david-a-wheeler/flawfinder.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "834e8b598e411e3722bb5955348293cc9ef833400ee0a45357525c91c13a29c6" => :catalina
    sha256 "834e8b598e411e3722bb5955348293cc9ef833400ee0a45357525c91c13a29c6" => :mojave
    sha256 "834e8b598e411e3722bb5955348293cc9ef833400ee0a45357525c91c13a29c6" => :high_sierra
  end

  depends_on "python@3.8"

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
