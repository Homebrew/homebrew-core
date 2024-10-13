class Libidn < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/"
  url "https://ftp.gnu.org/gnu/libidn/libidn-1.42.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn-1.42.tar.gz"
  sha256 "d6c199dcd806e4fe279360cb4b08349a0d39560ed548ffd1ccadda8cdecb4723"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "3f7b0c8c74b68fcdcf253050770060ea3cd6bd2d7fd18f9c16f076d3dbffbd86"
    sha256 cellar: :any, arm64_sonoma:   "d342445da0046d7c00011f2ae04869066359318d77d24a9eeca8117436c0436c"
    sha256 cellar: :any, arm64_ventura:  "028793a845059cb3db2abe7de82e257c080df9d3be18457a1b765bd70e0918d3"
    sha256 cellar: :any, arm64_monterey: "0653633442ed419791ec797ba4856f4f11c1d56253332325624a7457f137d1fb"
    sha256 cellar: :any, sonoma:         "93f6802767b31f0f6b8baeafc8cbc07df4312879cf2416711bc22d66cda14690"
    sha256 cellar: :any, ventura:        "367c1d3e45212508a0a28291d4d750c6abdf6544ca9bd551c9f8367f176c0029"
    sha256 cellar: :any, monterey:       "f8600f13a5956e11500c5bb96435b2e41ac9ac0870839b630f42b6425a6c58e3"
    sha256               x86_64_linux:   "3cc66b8450c436a5047d8075a004be087d3f21b5322834ef741165487fad262b"
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-csharp",
                          "--with-lispdir=#{elisp}"
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system bin/"idn", "räksmörgås.se", "blåbærgrød.no"
  end
end
