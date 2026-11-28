class OsinfoDb < Formula
  desc "Osinfo database of operating systems for virtualization provisioning tools"
  homepage "https://libosinfo.org/"
  url "https://gitlab.com/libosinfo/osinfo-db/-/releases/v20260812/downloads/osinfo-db-20260812.tar.xz", using: :nounzip
  sha256 "f13ed6e1e480b5266d39cad7f0010febdf0265dfc45579de2fb34543bc6b35de"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://gitlab.com/libosinfo/osinfo-db.git"
  end

  bottle do
    manifest_sha256 "059ae57a632b60d0ac8fc72688618a28af04bb310aa0bc30fa773d14d6d9d370"
    sha256 cellar: :any_skip_relocation, all: "c478c34be23a267ad436ccd7e7dc241ed2d840b1b1ca45b19439f9bf3746234f"
  end

  depends_on "osinfo-db-tools" => [:build, :test]

  def install
    system "osinfo-db-import", "--dir=#{share}/osinfo", "osinfo-db-#{version}.tar.xz"
  end

  test do
    system "osinfo-db-validate", "--system"
  end
end
