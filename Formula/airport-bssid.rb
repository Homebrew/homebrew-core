class AirportBssid < Formula
  desc "associate to a specific bssid"
  homepage "https://qpshinqp.github.io/airport-bssid/"
  url "https://github.com/qpSHiNqp/airport-bssid/archive/0.1.0.tar.gz"
  sha256 "cf1e81298838aa3d072c280ef5d85dc574958479083f39684647a8c63865a113"
  head "https://github.com/qpSHiNqp/airport-bssid.git"
  def install
    xcodebuild
    bin.install "build/Release/airport-bssid"
  end

  test do
    system "airport-bssid"
  end
end
