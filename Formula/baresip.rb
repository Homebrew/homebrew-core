class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/v1.0.0.tar.gz"
  sha256 "7b008c0a5b4fccfa0a4003f86dc4aaafeaabbdd259ece4757898e9cb5f04fdcf"
  license "BSD-3-Clause"

  bottle do
    sha256 "26b195eb72f39e12b796100935469105d0a07968cf38d9dc1febec3322e40939" => :big_sur
    sha256 "dd71d2ba58f82dd58b4da6c350b2d52ff4e04fe64679a446778615550dfb95b8" => :catalina
    sha256 "ec2fb4cba298c281b40a0929c227b563508ecaf5564e9381872c14469fb73ef9" => :mojave
    sha256 "b99e262d153eb3414c2a6fe813be98e78f71da205d66ede0ec799d1e07f0341a" => :high_sierra
  end

  depends_on "librem"

  resource "libre" do
    url "https://github.com/baresip/re/archive/v1.1.0.tar.gz"
    sha256 "82afc903a6b1e436b357f05eb11560ec681712291dd9c83c408465c895f28b5d"
  end

  def install
    # baresip doesn't like the 10.11 SDK when on Yosemite
    if MacOS::Xcode.version.to_i >= 7
      ENV.delete("SDKROOT")
      ENV.delete("HOMEBREW_SDKROOT") if MacOS::Xcode.without_clt?
    end

    resource("libre").stage do
      system "make", "SYSROOT=#{MacOS.sdk_path}/usr", "install", "PREFIX=#{libexec}/libre"
    end

    system "make", "install", "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libexec}/libre/share/re/re.mk",
                              "LIBRE_INC=#{libexec}/libre/include/re",
                              "LIBRE_SO=#{libexec}/libre/lib",
                              "MOD_AUTODETECT=",
                              "USE_AVCAPTURE=1",
                              "USE_COREAUDIO=1",
                              "USE_G711=1",
                              "USE_OPENGL=1",
                              "USE_STDIO=1",
                              "USE_UUID=1",
                              "HAVE_GETOPT=1"
  end

  test do
    system "#{bin}/baresip", "-f", "#{ENV["HOME"]}/.baresip", "-t", "1"
  end
end
