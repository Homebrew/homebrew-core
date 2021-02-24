class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/imageworks/OpenColorIO/archive/v2.0.0.tar.gz"
  sha256 "b407afcbcaecad8409545857796b9b6e27b0be0c85f2b9e7aa7d251bdc3a4416"
  license "BSD-3-Clause"
  head "https://github.com/imageworks/OpenColorIO.git"

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "3f501b862fd81a38e3395b74cea1c315222cae167d218bf29e9781880b40bc60"
    sha256 big_sur:       "cac7814fd18e6b7bfafc5e00a2b0bd82ff31bc8c93b80fb6d50b5c89816081b8"
    sha256 catalina:      "f421a922c08d79d16cb3b13a0bd5e89391b532d3d4f4bd673a265d01c21913da"
    sha256 mojave:        "f1300eca64637ad73adbfb2d3a77e59d65b5eae008fbbf4676d30555636f645e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "little-cms2"
  depends_on "python@3.9"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_VERBOSE_MAKEFILE=OFF
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DPYTHON=python3
      -DPYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/"python3"
    ]

    mkdir "macbuild" do
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      OpenColorIO requires several environment variables to be set.
      You can source the following script in your shell-startup to do that:
        #{HOMEBREW_PREFIX}/share/ocio/setup_ocio.sh

      Alternatively the documentation describes what env-variables need set:
        https://opencolorio.org/installation.html#environment-variables

      You will require a config for OCIO to be useful. Sample configuration files
      and reference images can be found at:
        https://opencolorio.org/downloads.html
    EOS
  end

  test do
    assert_match "validate", shell_output("#{bin}/ociocheck --help", 1)
  end
end
