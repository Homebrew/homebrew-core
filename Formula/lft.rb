class Lft < Formula
  desc "Layer Four Traceroute (LFT), an advanced traceroute tool"
  homepage "https://pwhois.org/lft/"
  url "https://pwhois.org/dl/index.who?file=lft-3.79.tar.gz"
  sha256 "08e5c7973551b529c850bffbc7152c4e5f0bcb1f07ebbb39151a7dc9a3bf9de0"

  bottle do
    cellar :any_skip_relocation
    sha256 "68dfe5d46b55f399681245146a4ceee9b47c54b900d914e11c7897fb47c9f421" => :mojave
    sha256 "42f8215a6ef6acc8cb0ac860c8f671bacfb844c4ba8fa6ce0e305a7367d4ef1a" => :high_sierra
    sha256 "2d0f6de7ba8bc85736396ff20e8fa2a5d53fedc22a17d71a7858fcdb39afd0b0" => :sierra
    sha256 "664ce1a522f401dbff33f8e77e1443514e05c98924e1d44cbaee8403ecb3c2e0" => :el_capitan
    sha256 "65d4dc85d60073e1f90451c7a745dcfe4e85886caac5cbf307291bc7eed21113" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lft -v 2>&1")
  end
end
