class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/imageworks/OpenColorIO/archive/v2.0.1.tar.gz"
  sha256 "ff1397b4516fdecd75096d5b575d6a23771d0c876bbcfc7beb5a82af37adcdf9"
  license "BSD-3-Clause"
  head "https://github.com/imageworks/OpenColorIO.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "694c70fd1552c49f502983949fd0504d419465dc0883c884264fa747eaf2cba6"
    sha256 cellar: :any, big_sur:       "7faaf59f2708f30b80537ec1106b513b8538191f3ef376bf0f7c75cba6d0f118"
    sha256 cellar: :any, catalina:      "f5717b569e63c1f3de8e5064b4a3482bf78444ae080ae56a7f7f5e70b4848783"
    sha256 cellar: :any, mojave:        "6813acb5bb190308480a66a7a14787d22e85841ab86e144ce9a65b005facbe65"
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
