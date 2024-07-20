class LoyalsoldierGeoip < Formula
  desc "Convenient tool to merge, convert and lookup IP & CIDR"
  homepage "https://github.com/Loyalsoldier/geoip"
  url "https://github.com/Loyalsoldier/geoip/archive/refs/tags/202407250105.tar.gz"
  sha256 "bf2524d4f8dcbce3853ba9b0afc10a31fe252ad62ee40e3fa59a504524acc0a9"
  license any_of: ["CC-BY-SA-4.0", "GPL-3.0-or-later"]
  head "https://github.com/Loyalsoldier/geoip.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"geoip"
  end

  test do
    output = shell_output("#{bin}/geoip list")

    assert_match "All available input formats:", output
  end
end
