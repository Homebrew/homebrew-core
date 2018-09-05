class Alac < Formula
  desc "Basic decoder for Apple Lossless Audio Codec files (ALAC)"
  homepage "https://web.archive.org/web/20150319040222/craz.net/programs/itunes/alac.html"
  url "https://web.archive.org/web/20150510210401/craz.net/programs/itunes/files/alac_decoder-0.2.0.tgz"
  sha256 "7f8f978a5619e6dfa03dc140994fd7255008d788af848ba6acf9cfbaa3e4122f"

  bottle do
    cellar :any_skip_relocation
    sha256 "ffc34867982b3a942be2bfa1c9a561bc85270871b029c45a16fc11ffae899603" => :mojave
    sha256 "17bffb09018ddf7d96258b99860d75fb9a203037a356cb0f2e4c6c4520cdc4c3" => :high_sierra
    sha256 "3c833c71834ea65498c761d4fe444a26e97e107433de526ab55ad1fb0d36a2ba" => :sierra
    sha256 "4cb85c125553c6c2a49576790c5be5e0b89096569131df3b8576f3499e65ef5a" => :el_capitan
    sha256 "a3a54a254a147f3a1173870bdd2e9399043b3e506d8c04383f99cf3ce67a4fca" => :yosemite
    sha256 "20cca431ce69d7eb2e5d894ebbfffdbc633eef2b3447be6d0afdb7c25cac8c0e" => :mavericks
  end

  def install
    system "make", "CFLAGS=#{ENV.cflags}", "CC=#{ENV.cc}"
    bin.install "alac"
  end

  test do
    sample = test_fixtures("test.m4a")
    assert_equal "file type: mp4a\n", shell_output("#{bin}/alac -t #{sample}", 100)
  end
end
