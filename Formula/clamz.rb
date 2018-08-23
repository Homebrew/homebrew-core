class Clamz < Formula
  desc "Download MP3 files from Amazon's music store"
  homepage "https://code.google.com/archive/p/clamz/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/clamz/clamz-0.5.tar.gz"
  sha256 "5a63f23f15dfa6c2af00ff9531ae9bfcca0facfe5b1aa82790964f050a09832b"
  revision 1

  bottle do
    cellar :any
    sha256 "031520225192a8498bc21a4e69c539ea0811ed2773b7085ecf1e10b502f648de" => :mojave
    sha256 "0a0d293bb616f176c756c402b9d5d7528e42caa1767374d45b721b5a2e82094d" => :high_sierra
    sha256 "fd35e22d601781e32cf9c5264f351c989d732d0a516617e3431522fef55bde61" => :sierra
    sha256 "b960106e00e01e4dd8ff259feab6e0a1e399d373aa79d2b5d622f2ccf6f1e41b" => :el_capitan
    sha256 "e0ba09e61f28b4d224f20b0922277b849bff48ce8c7738e8d22fe1a514d56fe2" => :yosemite
    sha256 "70f9f355c7f53a6201b5e175dbc6db9b1f8b275327250a1e70e06d5c139c2a53" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clamz --version 2>&1")
  end
end
