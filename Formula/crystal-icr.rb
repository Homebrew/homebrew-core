class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/greyblake/crystal-icr"
  url "https://github.com/greyblake/crystal-icr/archive/v0.2.14.tar.gz"
  sha256 "5ce3ec01fd174faa9c3bcc171a5a8623b78b49772d1c94b630dc768549088aa5"

  bottle do
    sha256 "f8d35da8b01af8958e3379017c19d2814afd65dd04df216750b026a8742fb5de" => :sierra
    sha256 "4a7cbbb4b2ce556c637f05ea80a2fefb3b4329f1f4fd0dc05621c2e1538c6088" => :el_capitan
    sha256 "6d091aac0b338a6b63fbd032f2a9bd02b1d4f753b42ff543c8fc7f2ca8f82141" => :yosemite
  end

  depends_on "crystal-lang"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end
