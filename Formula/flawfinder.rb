class Flawfinder < Formula
  desc "Examines code and reports possible security weaknesses"
  homepage "https://www.dwheeler.com/flawfinder/"
  url "https://www.dwheeler.com/flawfinder/flawfinder-2.0.0.tar.gz"
  mirror "https://downloads.sourceforge.net/project/flawfinder/flawfinder-2.0.0.tar.gz"
  sha256 "1dece3dd21017b92f6857033bc729db3cf7d7ba8b58088534ed360bde5d0644f"

  head "https://git.code.sf.net/p/flawfinder/code.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec6ef745112c16c51a95b23d07f732217cd566fb2a9540e76d0faa810f5f87ed" => :sierra
    sha256 "e09de8c54903a470777109b927e9ebef62732c25de525112ed9e30f2bdc468bb" => :el_capitan
    sha256 "3e70dda4b6166ace3bf38b5a0d84a6e8b8b83301fee2b1a8d76cc0e50ae16654" => :yosemite
    sha256 "6c254ed71ea0023b5964e6aa723671e815ce225a0a035437d61122e4701098d8" => :mavericks
    sha256 "54738b160ec86432cc37393facdd6be55cbc54c2dd080e26ee57493d72d8b6da" => :mountain_lion
  end

  resource "flaws" do
    url "https://www.dwheeler.com/flawfinder/test.c"
    sha256 "4a9687a091b87eed864d3e35a864146a85a3467eb2ae0800a72e330496f0aec3"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    resource("flaws").stage do
      assert_match "Hits = 36",
                   shell_output("#{bin}/flawfinder test.c")
    end
  end
end
