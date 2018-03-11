class Libbladerf < Formula
  desc "bladeRF USB 3.0 Superspeed Software Defined Radio Source"
  homepage "https://nuand.com/"
  url "https://github.com/Nuand/bladeRF/archive/2016.06.tar.gz"
  sha256 "6e6333fd0f17e85f968a6180942f889705c4f2ac16507b2f86c80630c55032e8"
  revision 1
  head "https://github.com/Nuand/bladeRF.git"

  bottle do
    sha256 "a6aa49db1410c4d2c43edd8564efa6a962093ac88132183d28aa5d09591fe3c3" => :el_capitan
    sha256 "fa8f653507ad414695029cdf1620de47e8bf0fb7901531f1ea241f39768db377" => :yosemite
    sha256 "0db3f3411af41d50509487ab199092d2264aca0ab6212616d0ff8ec008cdc612" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "libusb"

  # Fix cmake issue https://github.com/Nuand/bladeRF/issues/509
  # Remove for next version
  patch do
    url "https://github.com/Nuand/bladeRF/commit/037e2886.diff?full_index=1"
    sha256 "53de19bb7ce0790e5e5795ec8b95ac2014e3c883ceec13d6162f3d6362b77fea"
  end

  # Fix clockid_t failure https://github.com/Nuand/bladeRF/issues/493
  # Remove for next version
  if MacOS.version >= :sierra
    patch do
      url "https://github.com/Nuand/bladeRF/commit/21690e5d.diff?full_index=1"
      sha256 "9104dd0eed5073ba9ff2ea2b464bbe07f497928cd5023e1d5b417b595bc24029"
    end
  end

  def install
    mkdir "host/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"bladeRF-cli", "--version"
  end
end
