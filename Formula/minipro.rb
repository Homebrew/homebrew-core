class Minipro < Formula
  desc "Open controller for the MiniPRO TL866xx series of chip programmers"
  homepage "https://gitlab.com/DavidGriffith/minipro/"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/DavidGriffith/minipro.git", branch: "master"

  stable do
    url "https://gitlab.com/DavidGriffith/minipro/-/archive/0.6/minipro-0.6.tar.gz"
    sha256 "16b4220b5fc07dddc4d1d49cc181a2c6a735c833cc27f24ab73eac2572c9304a"

    # Fix version number, remove in next release
    patch do
      url "https://gitlab.com/DavidGriffith/minipro/-/commit/6b0074466ea5e2c2664362b5fcba4bc8b0172a44.diff"
      sha256 "a71e107701ff17d1731c3aa57868a822106b0fe1f808f40a88cfbe236faed289"
    end
  end

  bottle do
    sha256 arm64_ventura:  "c3fb5f07a52ff36e6a477c432a3f6519ebaa1648a8370843c6e873b3bfa8ee38"
    sha256 arm64_monterey: "5ca7bf6b78312ce94a7ce84a1f2e846f76b4932ad18b3e9f2c5549b8a45cd684"
    sha256 arm64_big_sur:  "2494b2555acb90436d868b9d1487a0fc53ad8db168be6fd3a4699e04aa0e7165"
    sha256 ventura:        "5c6f3e4eaf2ea7492e319ff09dc6b47a7f0849723eee2372fd3d33a31feb747f"
    sha256 monterey:       "7d955b7ea2350118bdd03baee5e366648ff5aa43ed14aa6b8f4d09e794a46870"
    sha256 big_sur:        "8661941fc4441e0a8dc145030f60cf20c171159612ec2b1135a3c5aa9aff698e"
    sha256 catalina:       "568b6057efc9388716d4ade043f0483d1a62bd510fb4dc9be0c0d95bfd4e78eb"
    sha256 x86_64_linux:   "fb07f4a40d15f74501b8bbf7623598eb466464fd4d3b60df2dba32d90152b783"
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "srecord"

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
