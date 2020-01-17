class Mobiledevice < Formula
  desc "CLI for Apple's Private (Closed) Mobile Device Framework"
  homepage "https://github.com/imkira/mobiledevice"
  url "https://github.com/imkira/mobiledevice/archive/v2.0.0.tar.gz"
  sha256 "07b167f6103175c5eba726fd590266bf6461b18244d34ef6d05a51fc4871e424"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e7cace974bdc389f01ff6ec4fb0719cc73bd56ff485045b209150bae2bdc1462" => :mojave
    sha256 "b848e30f816b76adea5e301e00123ac80a624db9461ef3a8b1324d84ad5d7c44" => :high_sierra
    sha256 "0ff270eba2d01738d98d3a3a1570c46f2d0cdee93317b5b448e44d85ef4163c3" => :sierra
    sha256 "6e7b8b74e3fe54132245a6f6720a77385c1a0185d6b2fdfbdb7391229e9e8b7a" => :el_capitan
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
