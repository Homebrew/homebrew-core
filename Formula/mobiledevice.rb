class Mobiledevice < Formula
  desc "CLI for Apple's Private (Closed) Mobile Device Framework"
  homepage "https://github.com/imkira/mobiledevice"
  url "https://github.com/imkira/mobiledevice/archive/v2.0.0.tar.gz"
  sha256 "07b167f6103175c5eba726fd590266bf6461b18244d34ef6d05a51fc4871e424"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "6912247da18b0d7f033d37115939a67629b93d036458f1369944a58953c12f69" => :catalina
    sha256 "1d327ce17e123f4039b9b0e6c351277d8e781a6757dd23060b6b207d791380f8" => :mojave
    sha256 "7ac3822649356127001c8b452df55c1435c467938193f223da61bbcdf2a7c11b" => :high_sierra
  end

  # This is a simple change that permits building on newer versions of macOS.
  # Should be included in the next stable release.
  patch do
    url "https://github.com/imkira/mobiledevice/commit/0472188d875382c5535916bf4469a2de7696fd39.patch?full_index=1"
    sha256 "76094a3e39e287c88bb60c829d2e9ab8801f8638c116d95a16333198b236147b"
  end

  def install
    (buildpath/"symlink_framework.sh").chmod 0555
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/mobiledevice", "list_devices"
  end
end
