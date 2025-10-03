class Argon2 < Formula
  desc "Password hashing library and CLI utility"
  homepage "https://github.com/P-H-C/phc-winner-argon2"
  url "https://github.com/P-H-C/phc-winner-argon2/archive/refs/tags/20190702.tar.gz"
  sha256 "daf972a89577f8772602bf2eb38b6a3dd3d922bf5724d45e7f9589b5e830442c"
  license "Apache-2.0"
  revision 1
  head "https://github.com/P-H-C/phc-winner-argon2.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "afaa0b7c4c305b6b8ccef5abb4863d30fc1dfc537cc2bdc43e1c558df25723c6"
    sha256 cellar: :any,                 arm64_sequoia:  "4fe5808e09d5c48eac1991bb19bca51ac39517ae46d8e9f696580dc004c0bd08"
    sha256 cellar: :any,                 arm64_sonoma:   "c503692d2a7d5538d5cb241b69c283d998bde91b38e3065c01bc79fdbe8cd197"
    sha256 cellar: :any,                 arm64_ventura:  "016bdb5f9f24c58d77c34daa974103a22a80d7ded572c2cb2d4586c97b43eb62"
    sha256 cellar: :any,                 arm64_monterey: "498cea03c8c9f5ab7b90a0c333122415f0360c09f837cafae6d8685d6846ced2"
    sha256 cellar: :any,                 arm64_big_sur:  "192f3381abe337df8af214cf4dccef2cbfaa9c88df489b5cf9276cea9f8c6080"
    sha256 cellar: :any,                 sonoma:         "00b61d421980e47df314b7b4ca74d3ed12ebf2eab0f35cb1013d0e397700c6bc"
    sha256 cellar: :any,                 ventura:        "22435030bed2a599098ef4cd239153d2c3c9b5b4b5bbe2390d32f3f9a35a96fd"
    sha256 cellar: :any,                 monterey:       "decd61f1d853225582aaa70e9f67438c21f45105118d86ddb69a5e494311a841"
    sha256 cellar: :any,                 big_sur:        "a9dd363964a2a633ace13aff04e4c5eac7e720d44faf377456de55396647ff13"
    sha256 cellar: :any,                 catalina:       "f8e550c8597728bb9edc5a548497fd7b1219203932cd0f93ecc97a4fbf0bdad8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1149cb3482d46eb06f07d77b2d3e3ff3f71599f573bf32553c4407f0b470c45c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58b4014f120e135a991f1023f210366ef3e9175a37a05a3fffb06a9fe3c23ff4"
  end

  def install
    system "make", "PREFIX=#{prefix}", "ARGON2_VERSION=#{version}", "LIBRARY_REL=lib"
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}", "ARGON2_VERSION=#{version}", "LIBRARY_REL=lib"
    doc.install "argon2-specs.pdf"
  end

  test do
    output = pipe_output("#{bin}/argon2 somesalt -t 2 -m 16 -p 4", "password", 0)
    assert_match "c29tZXNhbHQ$IMit9qkFULCMA/ViizL57cnTLOa5DiVM9eMwpAvPw", output
  end
end
