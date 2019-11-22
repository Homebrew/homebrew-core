class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.1.5.tar.gz"
  sha256 "fba0de08136af05038c2375e24f0eb2cfddf46caa2ec946dc1417d72d1108fed"
  head "https://github.com/maxmind/geoipupdate.git"

  bottle do
    sha256 "f1f1f4edb2b53a113a5e2be4fda3603aee435246a4e47a239c8a3f9cd7410364" => :catalina
    sha256 "739559a526ddae5d6e392ef3853d9a26003f2cf24191f64cb22c3b06ef526d4a" => :mojave
    sha256 "ec0ed3c37ea5b26f2fee4166f2f46d1da7af3d32f444186ddb50e55071362fad" => :high_sierra
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
