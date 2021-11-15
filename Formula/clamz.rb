class Clamz < Formula
  desc "Download MP3 files from Amazon's music store"
  homepage "https://code.google.com/archive/p/clamz/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/clamz/clamz-0.5.tar.gz"
  sha256 "5a63f23f15dfa6c2af00ff9531ae9bfcca0facfe5b1aa82790964f050a09832b"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "33fb7758d8552198b057d9ee8b7bf3e5c1e3b4ba580deb9a00f44edc468feda6"
    sha256 cellar: :any,                 arm64_big_sur:  "865348260858f74e779a47308f521ad54168b7a5d521313993a5f7f28fa53f44"
    sha256 cellar: :any,                 monterey:       "60b4d942e6b8fb59c134cd5776893216f6f5c9d44ac39023c81e1ed43f761e75"
    sha256 cellar: :any,                 big_sur:        "d7f6f8dc57d5498a54cd78356bc3097aa713a9000e876a6d3aaa12a10540d9d4"
    sha256 cellar: :any,                 catalina:       "6dc5a22ec8b190b91bc3e825a23063f6096f447ed24cabf6d5bcb19da8ef58f3"
    sha256 cellar: :any,                 mojave:         "031520225192a8498bc21a4e69c539ea0811ed2773b7085ecf1e10b502f648de"
    sha256 cellar: :any,                 high_sierra:    "0a0d293bb616f176c756c402b9d5d7528e42caa1767374d45b721b5a2e82094d"
    sha256 cellar: :any,                 sierra:         "fd35e22d601781e32cf9c5264f351c989d732d0a516617e3431522fef55bde61"
    sha256 cellar: :any,                 el_capitan:     "b960106e00e01e4dd8ff259feab6e0a1e399d373aa79d2b5d622f2ccf6f1e41b"
    sha256 cellar: :any,                 yosemite:       "e0ba09e61f28b4d224f20b0922277b849bff48ce8c7738e8d22fe1a514d56fe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bedccbcf92f7884cf99615ea347345f035a6693e953b6ebf90e51695e4351c95"
  end

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "libgpg-error"

  uses_from_macos "curl"
  uses_from_macos "expat"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clamz --version 2>&1")
  end
end
