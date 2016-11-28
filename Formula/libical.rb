class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v2.0.0/libical-2.0.0.tar.gz"
  sha256 "654c11f759c19237be39f6ad401d917e5a05f36f1736385ed958e60cf21456da"

  bottle do
    sha256 "89a2b365a23f3d99a24f62c45d060daabc0aa06c07f613bf47997db2a5caeca5" => :sierra
    sha256 "6ae0580e27fa630e88b8b460b82e3c995638e87d312c4e836425dbc321ae1bcb" => :el_capitan
    sha256 "eaef148f778ac575b2e1c3223cd26c8865d3ae86e274b1cab7bcf9b575086c38" => :yosemite
    sha256 "51288631d0f0656fdbe6d30eb333699e0f1c48a0b1defe72a9a7a3eeb0571a92" => :mavericks
    sha256 "014c0160a5bc9030409e6459799e4b9ae3474ea86d4ca1557b9a3d5d89e31232" => :mountain_lion
  end

  option :universal

  depends_on "cmake" => :build

  def install
    # Fix libical-glib build failure due to undefined symbol
    # Upstream issue https://github.com/libical/libical/issues/225
    inreplace "src/libical/icallangbind.h", "*callangbind_quote_as_ical_r(",
                                            "*icallangbind_quote_as_ical_r("
    args = std_cmake_args
    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mkdir "build" do
      system "cmake", "..", "-DSHARED_ONLY=true", *args
      system "make", "install"
    end
  end
end
