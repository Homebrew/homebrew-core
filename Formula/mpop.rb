class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.5.tar.xz"
  sha256 "5b69723b216d4330b93af81b487952e5897dcde782e3be65a4e79c87e420c7d4"

  bottle do
    cellar :any
    sha256 "f9961fbcc89cd345b57313ef8feb9b758af024cfd9536e052680d53467c48c43" => :mojave
    sha256 "5699bec2d56ed2d5a6d78b3acc0c8040d65edc237e0bca79316d5c7997a77bb1" => :high_sierra
    sha256 "9b567c18d9d4bbd384bb144daefbc2f0d670bfa41f156ef95567988f23ffcc23" => :sierra
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
