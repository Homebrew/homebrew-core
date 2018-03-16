class Mobiledevice < Formula
  desc "CLI for Apple's Private (Closed) Mobile Device Framework"
  homepage "https://github.com/imkira/mobiledevice"
  url "https://github.com/imkira/mobiledevice/archive/v2.0.0.tar.gz"
  sha256 "07b167f6103175c5eba726fd590266bf6461b18244d34ef6d05a51fc4871e424"

  depends_on MaximumMacOSRequirement => :sierra

  bottle do
    cellar :any_skip_relocation
    sha256 "53f8b0184fc5c88f112c380da96e3d86744242c32c6f8abeaf670a8d65e3a74c" => :sierra
    sha256 "27f7b9fa9c4f1e34711c75bef34a06925ca50933987d1f925587a356492f7046" => :el_capitan
    sha256 "110dd69008feb20cbe6343169dfcc278d209e9430d59d44ab0bf6ce7eb920362" => :yosemite
    sha256 "18d5472c4b517413472be3b97ff66217d55690773ef952933e652dc8a57133bf" => :mavericks
    sha256 "19eb775bc12305341abe780c06308cf32f5fd6060227fefa4cd0f2ef28a3dae2" => :mountain_lion
  end

  def install
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/mobiledevice", "list_devices"
  end
end
