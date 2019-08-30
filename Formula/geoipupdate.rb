class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.0.4.tar.gz"
  sha256 "1d490a32729db6cb91741ae14e04779cc86f91552d2fc2d51e3403078382ddc7"
  head "https://github.com/maxmind/geoipupdate.git"

  bottle do
    sha256 "357dd1bf6c2db75be03492db5e9533dcf523e9f48b66a0f2fda0d2ce0c1e846f" => :mojave
    sha256 "76dc1604ba9d225f97c243770e44f540821b4ecabe0f37a7890c297b843fa08d" => :high_sierra
    sha256 "e63cecbe96d7430e8070abd319f6c2203f63d324c8752b60a15db4d4b0e96a08" => :sierra
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
