class Minipro < Formula
  desc "Open controller for the MiniPRO TL866xx series of chip programmers"
  homepage "https://gitlab.com/DavidGriffith/minipro/"
  url "https://gitlab.com/DavidGriffith/minipro/-/archive/0.7.3/minipro-0.7.3.tar.gz"
  sha256 "49e7ddd448c12e1235631720bfbbe03dee3758ce717c16258a297112fb2a5eea"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/DavidGriffith/minipro.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "c2262f766cd51c2f60136665bb54b28479895f2f45e3132fa6347f4653865619"
    sha256 arm64_sonoma:  "c7cc2ecf133cb887aeaf2789a5182fd7e2254a002458e96597a5bbfea7b80903"
    sha256 arm64_ventura: "35da060df2788344cb4961b20d12d07f46af3b91f57205d29ff4eb8b0d04c71d"
    sha256 sonoma:        "ca12a15a1d8c7e34a91effb9f626d69a0cee7767e57b551411b9d1c629282c88"
    sha256 ventura:       "eda2df1cfd62ac8a350a42fbcba5d5d7d9949966c173f1b49dc67da079851ac7"
    sha256 arm64_linux:   "2bf6d4454b10358270335f584f2e985e521759d0a87cf972dd0678c194411f3b"
    sha256 x86_64_linux:  "92dd7c6ee958eabca1365c51859dc4c959406623cb963e0c41075b09fc54f97d"
  end

  depends_on "pkgconf" => :build
  depends_on "libusb"
  depends_on "srecord"

  uses_from_macos "zlib"

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{share}", "install"
  end

  test do
    output_minipro = shell_output("#{bin}/minipro 2>&1", 1)
    assert_match "minipro version #{version}", output_minipro

    output_minipro_read_nonexistent = shell_output("#{bin}/minipro -p \"ST21C325@DIP7\" -b 2>&1", 1)
    if output_minipro_read_nonexistent.exclude?("Device ST21C325@DIP7 not found!") &&
       output_minipro_read_nonexistent.exclude?("Error opening device") &&
       output_minipro_read_nonexistent.exclude?("No programmer found.")
      raise "Error validating minipro device database."
    end
  end
end
