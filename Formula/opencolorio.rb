class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/imageworks/OpenColorIO/archive/v2.0.1.tar.gz"
  sha256 "ff1397b4516fdecd75096d5b575d6a23771d0c876bbcfc7beb5a82af37adcdf9"
  license "BSD-3-Clause"
  head "https://github.com/imageworks/OpenColorIO.git"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "ff7921b54ca7e0589fff3dbf2e8f2b071b0f503f1657f4963d80749a8c5aedf0"
    sha256 cellar: :any, big_sur:       "94fc18f52a783c11afd946c72b100bf16d570767d5934b245c03cabb3f9de715"
    sha256 cellar: :any, catalina:      "8dcc8e3561f9e564239366ed88a2488b36af37c022e8b98f94e2d6cb1e718bde"
    sha256 cellar: :any, mojave:        "c0fa4803986b6960a3a3578f6e453428864eff5fb7ed5f51fd6c505258cc0ca5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "little-cms2"
  depends_on "python@3.9"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_VERBOSE_MAKEFILE=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
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
