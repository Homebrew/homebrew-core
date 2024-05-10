class Iozone < Formula
  desc "File system benchmark tool"
  homepage "https://www.iozone.org/"
  url "https://www.iozone.org/src/current/iozone3_494.tgz"
  sha256 "a36d43831e2829dbc9dc3d5a5a7eb1ca733c9ecc8cbb634022a52928e9b78662"
  license :cannot_represent

  livecheck do
    url "https://www.iozone.org/src/current/"
    regex(/href=.*?iozone[._-]?v?(\d+(?:[._]\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7435eb5705fa625d40411592f84a576933f946ef6e1ba4cb0ace51f8ce1f32ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "120ac4967eb1ed381019643a0b57fd9935bccfe57f4a6a62d73db5971c12f68a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d764fcef8796a89fbc4851a738544d4fe5f4a2d946804466c38c54200cf8fe5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d224ac1cd5bf43cc51595ac642b6b8b511c05b694a8c7bd0eb9e040973aa68fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "0aa76a5756e652719f9689638ffbf65f01a63a364166e365607d0e90564fc096"
    sha256 cellar: :any_skip_relocation, ventura:        "bcc526a3555b9ab8efc4e061f40b64c1948db1fea941b07eacf61440fee3b294"
    sha256 cellar: :any_skip_relocation, monterey:       "0edd67fecabe2907d1a53d6c66d600408a3c357721284cec71c42099c56f3dc7"
    sha256 cellar: :any_skip_relocation, big_sur:        "30973f3d9664c0a4b585a20897c9764fb0556428d325afd5f196436eaf2b3d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce1ad65c55a81789572e6ce23fa2b089a52771615849cc7b4443f564f090a92b"
  end

  def install
    cd "src/current" do
      target = OS.mac? ? "macosx" : OS.kernel_name.downcase
      system "make", "clean"
      system "make", target, "CC=#{ENV.cc}"
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
