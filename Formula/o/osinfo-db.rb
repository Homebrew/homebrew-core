class OsinfoDb < Formula
  desc "Osinfo database of operating systems for virtualization provisioning tools"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/osinfo-db-20251212.tar.xz", using: :nounzip
  sha256 "06379250c91306c98cb9726af44eae5909dfdd5449f90331e904ae1221d8d5e7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/libosinfo/?C=M&O=D"
    regex(/href=.*?osinfo-db[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "26a46e573f1927bb33a3b0124ee80a9461519af1b7cbbf8e2b0a923b4c787f30"
  end

  depends_on "osinfo-db-tools" => [:build, :test]

  def install
    system "osinfo-db-import", "--dir=#{share}/osinfo", "osinfo-db-#{version}.tar.xz"
  end

  test do
    system "osinfo-db-validate", "--system"
  end
end
