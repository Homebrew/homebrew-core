class Gpatch < Formula
  desc "Apply a diff file to an original"
  homepage "https://savannah.gnu.org/projects/patch/"
  url "https://ftp.gnu.org/gnu/patch/patch-2.7.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/patch/patch-2.7.6.tar.xz"
  sha256 "ac610bda97abe0d9f6b7c963255a11dcb196c25e337c61f94e4778d632f1d8fd"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0958a773e875dfbab2e70e80cd10a0406eed6f92352ae432b44f4bf74dcce35e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c90e7baee17d21e0cb594db676912e108f7df68b71509e15d37edfadcd6b12e9"
    sha256 cellar: :any_skip_relocation, monterey:       "1a3e9eb276bb35ecb33bcdc50b689f1f7cebe1d014566754c5faa85e72251789"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c18141474072f9fac171680e75c77fa22af016d1cda998a052792980d9ce4f9"
    sha256 cellar: :any_skip_relocation, catalina:       "f539f83039bc989b16aac11becfaa933c6dc8088f6fa060a8e01e84ed0a61d77"
    sha256 cellar: :any_skip_relocation, mojave:         "c25bf27bae741a7ec1a16d19d449d28b4b4a2f225190f55badf86b64b0266f4d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "418d7ea9c3948a5d70bdca202bd56e5554eef7f105fc25449f041331db7f4f96"
    sha256 cellar: :any_skip_relocation, sierra:         "81e0fb63928b01d60b9d7a1f0bdbf262679888556bd055fd02f4f57a70cb87ad"
    sha256 cellar: :any_skip_relocation, el_capitan:     "bd67af8b9c24fa785a2da2a1d3475305593dbc183331aed657313e4066de3259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f49b09a0cf8b312de84a07f7dee7029a0965277baa080f5e4eb57c1457539325"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testfile = testpath/"test"
    testfile.write "homebrew\n"
    patch = <<~EOS
      1c1
      < homebrew
      ---
      > hello
    EOS
    pipe_output("#{bin}/patch #{testfile}", patch)
    assert_equal "hello", testfile.read.chomp
  end
end
