class Iozone < Formula
  desc "File system benchmark tool"
  homepage "https://www.iozone.org/"
  url "https://www.iozone.org/src/current/iozone3_492.tgz"
  sha256 "cece887183d19b566633761f69b50952300cd594327a126a8aea184afbaa18d7"
  license :cannot_represent

  livecheck do
    url "https://www.iozone.org/src/current/"
    regex(/href=.*?iozone[._-]?v?(\d+(?:[._]\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aa676ffe3625bd4127956e10b39e4e25f51f82bb14ca061062282b81dd20318e"
    sha256 cellar: :any_skip_relocation, big_sur:       "f47bc3f26886b9469cc471bdea595bacd0158199ad1892d2b1836100d617f1e5"
    sha256 cellar: :any_skip_relocation, catalina:      "ac6f70cec9ffbf1c4be9feeb737bdf2eefeed1a9f9c62f6c4609fd08b6a3de4a"
    sha256 cellar: :any_skip_relocation, mojave:        "8098476c90a74f06fa73eda62e402629fd179b2f008f59fc97d2f0b5dd633ab5"
  end

  def install
    cd "src/current" do
      if OS.mac?
        system "make", "macosx", "CC=#{ENV.cc}"
      else
        system "make", "linux", "CC=#{ENV.cc}"
      end
      bin.install "iozone"
      pkgshare.install %w[Generate_Graphs client_list gengnuplot.sh gnu3d.dem
                          gnuplot.dem gnuplotps.dem iozone_visualizer.pl
                          report.pl]
    end
    man1.install "docs/iozone.1"
  end

  test do
    assert_match "File size set to 16384 kB",
      shell_output("#{bin}/iozone -I -s 16M")
  end
end
