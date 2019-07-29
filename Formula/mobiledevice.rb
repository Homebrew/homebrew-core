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

  # Upstream is pretty dead but this is a simple change
  # that permits building on newer versions of macOS.
  patch do
    url "https://github.com/imkira/mobiledevice/pull/20.patch?full_index=1"
    sha256 "adb46783a6cce1e988e2efd3440e2991ac5c5ce55f59b9049c9ccc2936ae8a02"
  end

  def install
    (buildpath/"symlink_framework.sh").chmod 0555
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/mobiledevice", "list_devices"
  end
end
