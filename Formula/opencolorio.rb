class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/v2.1.2.tar.gz"
  sha256 "6c6d153470a7dbe56136073e7abea42fa34d06edc519ffc0a159daf9f9962b0b"
  license "BSD-3-Clause"
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2394a606bf2c81345d434f6d4256aa5221058c3eb7fa938468bd01b617b3ac20"
    sha256 cellar: :any,                 arm64_big_sur:  "f6668fec2e276f024eb9c341f42e9a0d83974e6aa4c35798ecdcf57ba57ff662"
    sha256 cellar: :any,                 monterey:       "6ab80bb1cf81ce78367511863b6a82361723bdf938ba9ba12556863ee6113e2b"
    sha256 cellar: :any,                 big_sur:        "b7235c4ebdec6cb5172d50a50532a8e9be31be23bbc2d0926a91c46f1ac5e349"
    sha256 cellar: :any,                 catalina:       "a8c4db5c6a1854af480deffa8c7837c19612dc25dfd6c961192e1751cd8fe1fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "678355de0343ede44fc52bdc7cf9ac530935f5df7a75c5d3678e8d505fe0b425"
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
