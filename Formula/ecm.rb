class Ecm < Formula
  desc "Prepare CD image files so they compress better"
  homepage "https://web.archive.org/web/20140227165748/www.neillcorlett.com/ecm/"
  url "https://web.archive.org/web/20091021035854/www.neillcorlett.com/downloads/ecm100.zip"
  version "1.0"
  sha256 "1d0d19666f46d9a2fc7e534f52475e80a274e93bdd3c010a75fe833f8188b425"

  bottle do
    cellar :any_skip_relocation
    sha256 "888612dee7486ca5413e2b1e0090a4e1bd5ea7f2fe5cc53fe02bb326ed4f3d4c" => :sierra
    sha256 "3ecb325a368ef42737e77003e9ecc13a8d402a34da3a25c039b36565fef0b55d" => :el_capitan
    sha256 "9eef5eb54af2ad50ab05ee9382efe8d0ca831a6d058fe1fa2679cff87aa0a064" => :yosemite
    sha256 "c80a78299a5042d8588806066af2b03e9a3a679e8284fb863d9ee15edc690933" => :mavericks
  end

  def install
    system ENV.cc, "-o", "ecm", "ecm.c"
    system ENV.cc, "-o", "unecm", "unecm.c"
    bin.install "ecm", "unecm"
  end
end
