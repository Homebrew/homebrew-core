class Libbladerf < Formula
  desc "bladeRF USB 3.0 Superspeed Software Defined Radio Source"
  homepage "https://nuand.com/"
  url "https://github.com/Nuand/bladeRF/archive/2016.06.tar.gz"
  sha256 "6e6333fd0f17e85f968a6180942f889705c4f2ac16507b2f86c80630c55032e8"
  revision 1
  head "https://github.com/Nuand/bladeRF.git"

  bottle do
    sha256 "67091f5edf6c3108798b87e45d1f3a81f601037f1b5fa2fd25232ddd7e68a36b" => :mojave
    sha256 "1aaf3355a29e6c318555afc4a4aff2c76957976c7cf00113af5cacc8a171ab75" => :high_sierra
    sha256 "711db5a38f3a217cd3fe54c19fe8624bdb6d7b4431176a74541e819414a064d1" => :sierra
    sha256 "9de01abf00d154167160155eb6c64e9c9f83f11f8c0ce2ba862e94db43c9cbe2" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
