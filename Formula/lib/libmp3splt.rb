class Libmp3splt < Formula
  desc "Utility library to split mp3, ogg, and FLAC files"
  homepage "https://mp3splt.sourceforge.net/mp3splt_page/home.php"
  url "https://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.9.2/libmp3splt-0.9.2.tar.gz"
  sha256 "30eed64fce58cb379b7cc6a0d8e545579cb99d0f0f31eb00b9acc8aaa1b035dc"
  license "GPL-2.0-only"
  revision 6

  # We check the "libmp3splt" directory page since versions aren't present in
  # the RSS feed as of writing.
  livecheck do
    url "https://sourceforge.net/projects/mp3splt/files/libmp3splt/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+[a-z]?)/?["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 arm64_sequoia:  "e31a09566eee7d33d8651ab83872b7901e404bc536806dacb359becf2c784fdd"
    sha256 arm64_sonoma:   "ee6cd10b82e446a48c36e769b33e4a7d706c832111e72a9d3847d18f727524da"
    sha256 arm64_ventura:  "590a704b1d379b286d91f152ec8e9dda4bdac13635d7621a61e7a69d049c8d0f"
    sha256 arm64_monterey: "71fd93524a5a30b9c643151e376e16271b6ebdb7158a89a0d67761c84f0f4667"
    sha256 sonoma:         "c24510f2bd1c336a844ec2c6cab805a0ade60948c3ce098be49a0172b43be76d"
    sha256 ventura:        "759e7813fb3cb7dadba9c539aeca84f18f6b2dd9f7f84c7c197e12d9d0adf19a"
    sha256 monterey:       "a81be532fc8d2b8f1e0cdc293d47130a9d361e9133d6117442e23cee79bc411b"
    sha256 x86_64_linux:   "61f6d9accf005b87e7ef35000094703019abab54d6e7b851019552060cc93aae"
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "gettext"
  depends_on "libid3tag"
  depends_on "libogg"
  depends_on "libtool"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "pcre"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
