class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.30.tar.gz"
  sha256 "305647377527a2827223065582dd8a9269e69866426b341699d55bb4e4d3cc71"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a54298558d6ec284b0c386c805321908737dc18dcf7f863ea117eb96885e443c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6acb5047002646b69bad67a43080def0c766ee3e0b43bc2ab93e7f4ab181cce"
    sha256 cellar: :any_skip_relocation, monterey:       "16f60ea089a5ea940a2b98e564e37bf1a0dcdbbad3c3f826c4e2cabb387d0986"
    sha256 cellar: :any_skip_relocation, big_sur:        "5edec27c8f2bc586d4241dfc4d5a9ec4d1b614c09caba66ed0635553f5e0c45c"
    sha256 cellar: :any_skip_relocation, catalina:       "11861fee3b424af0e5442b62d54e458b1039bd6ce3917b8ff4a61ea4396eef16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3330391889dd52011905de2aac9ba77605fb9a96c97cd961959d3a1838e8638b"
  end

  uses_from_macos "zlib"

  def install
    system "./configure"
    # fio's CFLAGS passes vital stuff around, and crushing it will break the build
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "sharedir=#{share}",
                   "CC=#{ENV.cc}",
                   "V=true", # get normal verbose output from fio's makefile
                   "install"
  end

  test do
    system "#{bin}/fio", "--parse-only"
  end
end
