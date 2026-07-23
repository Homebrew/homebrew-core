class Libdiscid < Formula
  desc "C library for creating MusicBrainz and freedb disc IDs"
  homepage "https://musicbrainz.org/doc/libdiscid"
  url "https://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.7.0.tar.gz"
  sha256 "c230ed462c5ed7d7403ceb6984c57c8d05de42386d796bcd893636c0b0ba222f"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/"
    regex(/href=.*?libdiscid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fc45e6f5f937c3769bc2ecefda8c87876c13c480256c2d4418a5efe82524dce6"
    sha256 cellar: :any, arm64_sequoia: "aaf2881b3b65a00777e497249afcf0f95b7fe51c8375c60aec3446148896c8f7"
    sha256 cellar: :any, arm64_sonoma:  "b655f25d9cf870e3bd44cb9587a534ecc8e9475a87decccb3b77595fc067aa3c"
    sha256 cellar: :any, sonoma:        "c96b31f639b8f552783c91d069f0d75e98f49c4aa00bd2aa2266821936b467d3"
    sha256 cellar: :any, arm64_linux:   "32c4923845f7ee7a78b23b16ade61efd47a2ff63a4c96f4ecdababbd07064116"
    sha256 cellar: :any, x86_64_linux:  "fef1a5a18839392e32cff0187636167296c283189748a6f170744bc4a236448d"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
