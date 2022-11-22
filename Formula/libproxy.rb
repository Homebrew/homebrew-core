class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/0.4.17.tar.gz"
  sha256 "88c624711412665515e2800a7e564aabb5b3ee781b9820eca9168035b0de60a9"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/libproxy/libproxy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "d4df7a0e2c40acb852625f0a5a70b1c737fd5c13203787a929d1bb20f49f3190"
    sha256 arm64_monterey: "1de17b75f1c12ddacec2ace3a6152586bd49bdeeac07982b000c83486d3adeb3"
    sha256 arm64_big_sur:  "54df3618c53e7f3a55441b74319aa2c32ea68ee1d30a8287b8ad3f9cf58b8f8d"
    sha256 ventura:        "2c27a8613e1b335043ef94a4233553a04cefc47caf5fe0a44de7758ee8e2aeea"
    sha256 monterey:       "a74b532012e5169309a1ef4226792f3d7533204ee33bfccd5863340041f9a71c"
    sha256 big_sur:        "f4fe74825ca139acd6cef52317eade9511f2ff90b5b584b0ca1706729ad6cc8d"
    sha256 catalina:       "f9946d8dee8b0915e160343b112259e5bba99bfb28f51364bf17a9bf6aabb6eb"
    sha256 x86_64_linux:   "b8f12e9287c1ee704325efea0468632d56bc3852a5a40a2752ccee51a97d046b"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11"

  on_linux do
    depends_on "dbus"
    depends_on "glib"
  end

  def install
    args = std_cmake_args + %W[
      ..
      -DPYTHON3_SITEPKG_DIR=#{prefix/Language::Python.site_packages("python3.11")}
      -DWITH_PERL=OFF
      -DWITH_PYTHON2=OFF
    ]

    mkdir "build" do
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    assert_equal "direct://", pipe_output("#{bin}/proxy 127.0.0.1").chomp
  end
end
