class IconNamingUtils < Formula
  desc "Script to handle icon names in desktop icon themes"
  homepage "https://specifications.freedesktop.org/icon-naming-spec/icon-naming-spec-latest.html"
  # Upstream seem to have enabled by default SSL/TLS across whole domain which
  # is problematic when the cert is for www rather than a wildcard or similar.
  # url "http://tango.freedesktop.org/releases/icon-naming-utils-0.8.90.tar.gz"
  url "https://deb.debian.org/debian/pool/main/i/icon-naming-utils/icon-naming-utils_0.8.90.orig.tar.gz"
  sha256 "044ab2199ed8c6a55ce36fd4fcd8b8021a5e21f5bab028c0a7cdcf52a5902e1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ed447fa2e57d32cc048b551ee67339d2be52d89f124e9dfddb3322cc0882883" => :catalina
    sha256 "7845482b7512d560f5363c75ae0e6d457bb22d9f2bd1820052b580f65a689a1f" => :mojave
    sha256 "1ab22bc216fc60fe05436993a1d451542a5f57a12ecf835c85f5c850574e54f3" => :high_sierra
    sha256 "d824a2df63a9615bb242c197af07ce18f6a6a046df9c785fe31d5f39d986f4ed" => :sierra
    sha256 "f8a29d74289a555ba7969b8d8f6984de7251393d7d0270e61abf69d36f270fc0" => :el_capitan
    sha256 "22a80ba1d9042481251c8b85aa46dc163abfd9a54d6815ab43a3a5124592be5f" => :yosemite
    sha256 "1e2f32f1e755df8a974482ad56c0cc85f7d537005419b0c0c42013f0f0ab717d" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
