class OsinfoDb < Formula
  desc "Osinfo database of operating systems for virtualization provisioning tools"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/osinfo-db-20230719.tar.xz"
  sha256 "13d1c97fc7d67137935dcc97778c08bb079a4f0fe312d479786cea1411e4845a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/libosinfo/?C=M&O=D"
    regex(/href=.*?osinfo-db[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6efec181fc8f83e24cc6cc3ed5a014e5c4f0093644515314435dd5fd65530296"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6efec181fc8f83e24cc6cc3ed5a014e5c4f0093644515314435dd5fd65530296"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6efec181fc8f83e24cc6cc3ed5a014e5c4f0093644515314435dd5fd65530296"
    sha256 cellar: :any_skip_relocation, ventura:        "6efec181fc8f83e24cc6cc3ed5a014e5c4f0093644515314435dd5fd65530296"
    sha256 cellar: :any_skip_relocation, monterey:       "6efec181fc8f83e24cc6cc3ed5a014e5c4f0093644515314435dd5fd65530296"
    sha256 cellar: :any_skip_relocation, big_sur:        "6efec181fc8f83e24cc6cc3ed5a014e5c4f0093644515314435dd5fd65530296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d9b938741b0351313612482b4831f4057dce7f0af778d50d5fa1af67c9c60c9"
  end

  depends_on "osinfo-db-tools" => [:build, :test]

  def install
    system "osinfo-db-import", "--dir=#{share}/osinfo", cached_download
  end

  test do
    system "osinfo-db-validate", "--system"
  end
end
