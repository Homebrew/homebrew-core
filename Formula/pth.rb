class Pth < Formula
  desc "GNU Portable THreads"
  homepage "https://www.gnu.org/software/pth/"
  url "https://ftp.gnu.org/gnu/pth/pth-2.0.7.tar.gz"
  mirror "https://ftpmirror.gnu.org/pth/pth-2.0.7.tar.gz"
  sha256 "72353660c5a2caafd601b20e12e75d865fd88f6cf1a088b306a3963f0bc77232"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_big_sur: "746ea3501c80f444585f9e8c532815ff97cc94e050d1f5672307451abfb1bcfa"
    sha256 cellar: :any,                 big_sur:       "ce0bf2885f2ff76922d2306e84e328b3bcbe5b3c8365806a66f75d5fce0568fb"
    sha256 cellar: :any,                 catalina:      "4e468eea8984b9eb265dcd2f1e10a12ec5827088986042cea278b24f1a4dc1d4"
    sha256 cellar: :any,                 mojave:        "e7ed86c562756b07fcf9bb148c76f17c6cb4f3b02bf84ffe82285e3b279e7836"
    sha256 cellar: :any,                 high_sierra:   "da4549f9e89a71478b47f4454f9a259dc3a56a109f24083ce8f4ea69b11ac9c5"
    sha256 cellar: :any,                 sierra:        "583d6ae1681974c7461650151253c5a302f33fb16dae74b5546a4a693cec71d1"
    sha256 cellar: :any,                 el_capitan:    "bac7f73c061797768be28e21bec2e7773cfd70ff7c3f46eafd464b9632d5eae4"
    sha256 cellar: :any,                 yosemite:      "7b31c6d65a97c722e661feb4c73a59a9025f1eac6b297ff181931bbdbc894ff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66cd52703b09b137d33237be545677ba50729264ef0ad34d5f4c3891bba86173"
  end

  def install
    ENV.deparallelize

    # NOTE: The shared library will not be build with --disable-debug, so don't add that flag
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    system "#{bin}/pth-config", "--all"
  end
end
