class Flawfinder < Formula
  desc "Examines code and reports possible security weaknesses"
  homepage "https://www.dwheeler.com/flawfinder/"
  url "https://www.dwheeler.com/flawfinder/flawfinder-2.0.6.tar.gz"
  sha256 "d33caeb94fc7ab80b75d2a7a871cb6e3f70e50fb835984e8b4d56e19ede143fc"

  head "https://git.code.sf.net/p/flawfinder/code.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ce1dbcf1966511728bb4bffd74c00391835f2b2e10f51984546ebdde6f32879" => :high_sierra
    sha256 "3ce1dbcf1966511728bb4bffd74c00391835f2b2e10f51984546ebdde6f32879" => :sierra
    sha256 "3ce1dbcf1966511728bb4bffd74c00391835f2b2e10f51984546ebdde6f32879" => :el_capitan
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
