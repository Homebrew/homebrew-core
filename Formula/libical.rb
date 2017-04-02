class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v2.0.0/libical-2.0.0.tar.gz"
  sha256 "654c11f759c19237be39f6ad401d917e5a05f36f1736385ed958e60cf21456da"

  bottle do
    sha256 "4b8b3165661fca6ae137559f3b9d0436bee37284ce84c75e9e81677512bacd43" => :sierra
    sha256 "80cd45eebc20492169a98e26c2ac384d9e7d42c60c97dfb31cf15fa3c978ea27" => :el_capitan
    sha256 "f4cbcfb04208a01f1589f119e785c656b74713d033949e8a6a367a759ea142eb" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    # Fix libical-glib build failure due to undefined symbol
    # Upstream issue https://github.com/libical/libical/issues/225
    inreplace "src/libical/icallangbind.h", "*callangbind_quote_as_ical_r(",
                                            "*icallangbind_quote_as_ical_r("

    mkdir "build" do
      system "cmake", "..", "-DSHARED_ONLY=true", *std_cmake_args
      system "make", "install"
    end
  end
end
