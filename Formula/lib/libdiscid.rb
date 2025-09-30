class Libdiscid < Formula
  desc "C library for creating MusicBrainz and freedb disc IDs"
  homepage "https://musicbrainz.org/doc/libdiscid"
  url "https://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.6.5.tar.gz"
  sha256 "72dbb493e07336418fe2056f0ebc7ce544eedb500bb896cc1cc04bd078c2d530"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/"
    regex(/href=.*?libdiscid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4073b1cbed85a0c8cfb7cf9c79d797f6341935cd002692d3b415c9ebc1296364"
    sha256 cellar: :any,                 arm64_sequoia: "32dee47998c52dc9777f3d89e546cc788166acee77691c9ed809454c014b5d5a"
    sha256 cellar: :any,                 arm64_sonoma:  "9a8ba9144a0f2236dd623b190612be1a68c8a04353b85a71d9399b12d3477aea"
    sha256 cellar: :any,                 arm64_ventura: "0d872c138f40e4794d692c6c35cfc586305dcb71ec8a3d01c53c2600b86bda75"
    sha256 cellar: :any,                 sonoma:        "61962aaee44d489688a5f9e4e2d795aac681ce68257f9fc77a82372aae6bb557"
    sha256 cellar: :any,                 ventura:       "064aa65a001e73c25743a6637e8aefa6e22aae07fb17ab859cfb5d520559f08a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51d620c20901c02211bce728a9ae4eb94d978bd01178edc206dd38fd9ae80048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b1ee7a44ee8456f4a91d70158132952b84730f3b8b0851b3a6ae8e382e34c8a"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
