class Clamz < Formula
  desc "Download MP3 files from Amazon's music store"
  homepage "https://code.google.com/archive/p/clamz/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/clamz/clamz-0.5.tar.gz"
  sha256 "5a63f23f15dfa6c2af00ff9531ae9bfcca0facfe5b1aa82790964f050a09832b"
  license "GPL-3.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "0d263cb2b16259b06794b4470e155967eab994f538c670fdcb2db680c5c5f03f"
    sha256 cellar: :any,                 arm64_sequoia:  "60807a8f262d22bbae1e13db11d9a7d9765896cc3c0e08ab919194f94e114705"
    sha256 cellar: :any,                 arm64_sonoma:   "5a7a2bdd3815fdb9fd2647df980edcb43919b173cde53f5fd298b381b231d943"
    sha256 cellar: :any,                 arm64_ventura:  "b862bbcf8083563c7cd92b4325eabe6d69c8b7b178dd999181c2f0daa000e400"
    sha256 cellar: :any,                 arm64_monterey: "33fb7758d8552198b057d9ee8b7bf3e5c1e3b4ba580deb9a00f44edc468feda6"
    sha256 cellar: :any,                 arm64_big_sur:  "865348260858f74e779a47308f521ad54168b7a5d521313993a5f7f28fa53f44"
    sha256 cellar: :any,                 sonoma:         "e154f03f65107c9f7b3527cfc5d60bc42073ee99e0345c3c250e71a09333d6d6"
    sha256 cellar: :any,                 ventura:        "b86ee0daaee591232ce488b2a0a6e5d13266b59d715bba72e9e1158b2c6376fc"
    sha256 cellar: :any,                 monterey:       "60b4d942e6b8fb59c134cd5776893216f6f5c9d44ac39023c81e1ed43f761e75"
    sha256 cellar: :any,                 big_sur:        "d7f6f8dc57d5498a54cd78356bc3097aa713a9000e876a6d3aaa12a10540d9d4"
    sha256 cellar: :any,                 catalina:       "6dc5a22ec8b190b91bc3e825a23063f6096f447ed24cabf6d5bcb19da8ef58f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "57bbb9e4a40a6fba879e65f49b79177fe87c2c6a0592b4b06abc4a937535071c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bedccbcf92f7884cf99615ea347345f035a6693e953b6ebf90e51695e4351c95"
  end

  depends_on "pkgconf" => :build
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
