class Argon2 < Formula
  desc "Password hashing library and CLI utility"
  homepage "https://github.com/P-H-C/phc-winner-argon2"
  url "https://github.com/P-H-C/phc-winner-argon2/archive/20190702.tar.gz"
  sha256 "daf972a89577f8772602bf2eb38b6a3dd3d922bf5724d45e7f9589b5e830442c"
  license "Apache-2.0"
  revision 1
  head "https://github.com/P-H-C/phc-winner-argon2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "016bdb5f9f24c58d77c34daa974103a22a80d7ded572c2cb2d4586c97b43eb62"
    sha256 cellar: :any,                 arm64_monterey: "498cea03c8c9f5ab7b90a0c333122415f0360c09f837cafae6d8685d6846ced2"
    sha256 cellar: :any,                 arm64_big_sur:  "192f3381abe337df8af214cf4dccef2cbfaa9c88df489b5cf9276cea9f8c6080"
    sha256 cellar: :any,                 ventura:        "22435030bed2a599098ef4cd239153d2c3c9b5b4b5bbe2390d32f3f9a35a96fd"
    sha256 cellar: :any,                 monterey:       "decd61f1d853225582aaa70e9f67438c21f45105118d86ddb69a5e494311a841"
    sha256 cellar: :any,                 big_sur:        "a9dd363964a2a633ace13aff04e4c5eac7e720d44faf377456de55396647ff13"
    sha256 cellar: :any,                 catalina:       "f8e550c8597728bb9edc5a548497fd7b1219203932cd0f93ecc97a4fbf0bdad8"
    sha256 cellar: :any,                 mojave:         "a76192a41826619fc399e7f6de5e6cb1c8a5fbe6bea4f2c1554daa830fa0e296"
    sha256 cellar: :any,                 high_sierra:    "830016982e60870f50b3f6fc9a215d8cc4bda6061595f4883f7c11ab19ecba39"
    sha256 cellar: :any,                 sierra:         "21889ac6ed40c792f1b372b5aa0d6b3be1be86577a4c1b06b08569124d2d0da2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58b4014f120e135a991f1023f210366ef3e9175a37a05a3fffb06a9fe3c23ff4"
  end

  def install
    system "make", "PREFIX=#{prefix}", "ARGON2_VERSION=#{version}", "LIBRARY_REL=lib"
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}", "ARGON2_VERSION=#{version}", "LIBRARY_REL=lib"
    doc.install "argon2-specs.pdf"
  end

  test do
    output = pipe_output("#{bin}/argon2 somesalt -t 2 -m 16 -p 4", "password")
    assert_match "c29tZXNhbHQ$IMit9qkFULCMA/ViizL57cnTLOa5DiVM9eMwpAvPw", output
  end
end
