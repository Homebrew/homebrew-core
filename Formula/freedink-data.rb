class FreedinkData < Formula
  desc "Data for FreeDink."
  homepage "https://www.gnu.org/software/freedink/"
  url "https://ftpmirror.gnu.org/freedink/freedink-data-1.08.20170401.tar.xz"
  sha256 "e8d3f3ff55b1a86661949d08d901740d65a6092027886fd791f6c315b9c7a7ff"

  def install
    system "sed", "-i.bak", "-e", "s,^VERSION,#VERSION,", "-e", "s,^SOURCE_DATE_EPOCH,#SOURCE_DATE_EPOCH,", "-e", "s,xargs -0r,xargs -0,", "Makefile"
    version=Dir.pwd.split("/")[-1].split("-")[-1]
    source_date = Dir.pwd.split("/")[-1].split(".")[-1].match(/(\d{4})(\d{2})(\d{2})/).to_a[1..-1].join("-")
    source_date_epoch = Time.parse("#{source_date} 0:00 UTC").to_i
    system "make", "install", "VERSION=#{version}", "SOURCE_DATE_EPOCH=#{source_date_epoch}", "PREFIX=#{prefix}"
  end

  test do
    FileTest.exist?("#{share}/dink/dink/Dink.dat")
  end
end
