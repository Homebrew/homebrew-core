class Openalpr < Formula
  desc "Automatic License Plate Recognition library"
  homepage "https://www.openalpr.com"
  url "https://github.com/openalpr/openalpr/archive/v2.3.0.tar.gz"
  sha256 "1cfcaab6f06e9984186ee19633a949158c0e2aacf9264127e2f86bd97641d6b9"
  license "AGPL-3.0-or-later"
  revision 2

  bottle do
    sha256 big_sur:  "32953a90e352cc25eea99daad7fac67c7ce11f042fe366af029b16cc3f372c07"
    sha256 catalina: "0a05746932c63e1d0dd1749a7213ed0a9cff7d7da2cdfe49e032aeb1b1da56ad"
    sha256 mojave:   "64dd8cef3f2fe311304e0fffae5ed50dd37123d6611aae751ba272be956bf334"
  end

  depends_on "cmake" => :build
  depends_on "leptonica"
  depends_on "libtiff"
  depends_on "log4cplus"
  depends_on "opencv"
  depends_on "python@3.9"
  depends_on "tesseract"

  uses_from_macos "curl"

  # A photo of licence plate from https://commons.wikimedia.org/wiki/File:California_2018_license_plate_(USA).jpg
  resource "testdata" do
    url "https://upload.wikimedia.org/wikipedia/commons/b/b0/California_2018_license_plate_%28USA%29.jpg"
    sha256 "dd58b62f4f75690280dd0b021b19422cef7f4f4381664d3ee512106e6f491e5c"
  end

  # Make compatible with opencv 4
  # See https://github.com/openalpr/openalpr/pull/878
  # Remove in the next release
  patch do
    url "https://github.com/openalpr/openalpr/commit/a35f0d688e546392bf15e0d1d4ef73b6bc8d179d.patch?full_index=1"
    sha256 "c22c0773182badc6ff7a65c0a423b7a01d722788be192f1b4245b1bad8d15089"
  end

  # Fix compatibility with tesseract 4
  # See https://github.com/openalpr/openalpr/pull/693
  # Remove in the next release
  patch do
    url "https://github.com/openalpr/openalpr/commit/28e0b0fa95c12923138768d670b852242a750d0c.patch?full_index=1"
    sha256 "3c99b8fe00f7fbdc3840cdf0453154fd8d88bba90de7636137697194b9632b30"
  end

  # Fix Alpr#is_loaded segfault in python bindings
  # Remove in the next release
  patch do
    url "https://github.com/openalpr/openalpr/commit/479aa4edbfd3cd0062d73fd2e0457367b3dc522f.patch?full_index=1"
    sha256 "c08c4be680825e97f165500290eb387a37fb5569cd01cb1e6ed42991dabee920"
  end

  def install
    mkdir "src/build" do
      args = std_cmake_args
      args << "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}"
      args << "-DCMAKE_CXX_FLAGS=-std=c++11"
      args << "-DCMAKE_INSTALL_SYSCONFDIR:PATH=#{etc}"
      args << "-DWITH_BINDING_PYTHON=ON"
      args << "-DWITH_BINDING_JAVA=OFF"
      args << "-DWITH_BINDING_GO=OFF"
      args << "-DWITH_TESTS=OFF"
      args << "-DTesseract_PKGCONF_INCLUDE_DIRS=#{Formula["tesseract"].opt_include}/tesseract"
      args << "-DTesseract_PKGCONF_LIBRARY_DIRS=#{Formula["tesseract"].opt_lib}/tesseract"

      system "cmake", "..", *args
      system "make", "install"
    end

    (lib/"python2.7/dist-packages").rmtree
    cd "src/bindings/python" do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    resource("testdata").stage { testpath.install Dir["*.jpg"].first => "plate.jpg" }
    plate_number = "7TRR812"

    assert_match plate_number, shell_output("#{bin}/alpr plate.jpg")

    (testpath/"test.py").write <<~EOS
      from openalpr import Alpr

      try:
        alpr = Alpr("us", "#{etc}/openalpr/openalpr.conf", "#{share}/openalpr/runtime_data")
        if not alpr.is_loaded():
          raise RuntimeError("Error loading OpenALPR")
        alpr.set_top_n(7)
        alpr.set_default_region("ca")
        alpr.set_detect_region(False)
        with open("#{testpath}/plate.jpg", "rb") as f:
          print(alpr.recognize_array(f.read()))
      finally:
        if alpr:
          alpr.unload()
    EOS
    output = shell_output("#{Formula["python@3"].opt_bin}/python3 #{testpath}/test.py")
    assert_match plate_number, output
  end
end
