class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.5.tar.xz"
  sha256 "5b69723b216d4330b93af81b487952e5897dcde782e3be65a4e79c87e420c7d4"

  bottle do
    cellar :any
    sha256 "4eebe9be39b640d427b2504e1e1bdf38d697f5d13d9cd8d841689a09988c6d63" => :mojave
    sha256 "4119dbed882b706bf1fbeee25ea2c7d7badc7c6fe17969619149b9d4467da726" => :high_sierra
    sha256 "ceb8b967d93722e93986063d56ec6aa381b5919131eab333c577d725241d6a40" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end
