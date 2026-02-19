class Ccal < Formula
  desc "Create Chinese calendars for print or browsing"
  homepage "https://ccal.chinesebay.com/ccal/ccal.htm"
  url "https://ccal.chinesebay.com/ccal/ccal-2.5.3.tar.gz"
  sha256 "3d4cbdc9f905ce02ab484041fbbf7f0b7a319ae6a350c6c16d636e1a5a50df96"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?ccal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "886e52e30ce5de3a7be8fecca2367e09629a0832f48d286d61b122e77fc98f95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "514253e54ddbf113dd2bfbb6c18e70d7640e05a7fad9f5a833f4d62a582e571e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e29b7227b250b957eef3c4ad4f111147c20d81d511fbbdcd0940ae3eed77671"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5501517c464734afd6d7dde343bcce5508be8a298f861181d7bb41b799098ca9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c64a8df40556f6f6778bfa5f5dbe5b3f19bd96d8ff83d208fedc4bf13cabd032"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9555bba354683597a63cf86554624a01afbf7cc897c0e292b10edc3657f4572"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee50d26ab3751fc41169edaddf069136ead8167383d537d21d7580216ebb7c5f"
    sha256 cellar: :any_skip_relocation, ventura:        "ebcd46da3c774e8cfee8e5a480e9d6aa665646bef41eed5774056eb62dd03ae2"
    sha256 cellar: :any_skip_relocation, monterey:       "ad4cbfca5bf91baacefb99faef58acc28a6cf0517d31ba2b94e365d69bf43086"
    sha256 cellar: :any_skip_relocation, big_sur:        "82e5a0c59583063fdfa23e254f77ac5d7972a8fb5a3e36138233c7a47245abdf"
    sha256 cellar: :any_skip_relocation, catalina:       "ea42afd04ed210cf6e0bedac3ab4ce6b3e37421ba8d79478769d2e117c38a41f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c88444adaeb8ba5d457d6332da395b62ee03b8ffc25ec9001db44db2ce0fb15c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3d0a1bcea11bb75c5a13e8217bab044677bb6d8e905d84a2c4ba53d8b0b8e5e"
  end

  def install
    system "make", "-e", "BINDIR=#{bin}", "install"
    system "make", "-e", "MANDIR=#{man}", "install-man"
  end

  test do
    assert_match "Year JiaWu, Month 1X", shell_output("#{bin}/ccal 2 2014")
  end
end
