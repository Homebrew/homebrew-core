class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.0.4.tar.gz"
  sha256 "1d490a32729db6cb91741ae14e04779cc86f91552d2fc2d51e3403078382ddc7"
  head "https://github.com/maxmind/geoipupdate.git"

  bottle do
    sha256 "9258106805ea114bbc7703b855b8cf08f765457ed2fe924d46b68e5c01a1baba" => :mojave
    sha256 "8aa639ac343793ac2eeca63302dff9bb8df629a6740ca1b4fbc54468196ffeac" => :high_sierra
    sha256 "4e75d3e839c3e89ef8cadb332c94c6710b109eca8e9be7a8f60f05f609a11b08" => :sierra
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/maxmind/geoipupdate").install buildpath.children

    cd "src/github.com/maxmind/geoipupdate" do
      system "make", "CONFFILE=#{etc}/GeoIP.conf", "DATADIR=#{var}/GeoIP", "VERSION=#{version} (homebrew)"

      bin.install  "build/geoipupdate"
      etc.install  "build/GeoIP.conf"
      man1.install "build/geoipupdate.1"
      man5.install "build/GeoIP.conf.5"
    end
  end

  def post_install
    (var/"GeoIP").mkpath
    system bin/"geoipupdate", "-v"
  end

  test do
    system "#{bin}/geoipupdate", "-V"
  end
end
