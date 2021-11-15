class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/imageworks/OpenColorIO/archive/v2.1.0.tar.gz"
  sha256 "81fc7853a490031632a69c73716bc6ac271b395e2ba0e2587af9995c2b0efb5f"
  license "BSD-3-Clause"
  head "https://github.com/imageworks/OpenColorIO.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "21a13f41d923b2e0161c66cfb0663898030fe3da874c5290e900284e6bd5bfa2"
    sha256 cellar: :any,                 arm64_big_sur:  "36f49aa701d4121185e300594128b1b55264b7f0d8da930f3e195668fa63ee2d"
    sha256 cellar: :any,                 monterey:       "12fcb8770878dd0f01180c144adc5ea9fcedcea2b8b02f1164de8c49ccc3b861"
    sha256 cellar: :any,                 big_sur:        "e948b41de75e637b6e458eac15d2d018d2dce9a060b9b24e4be9cf4c689e9820"
    sha256 cellar: :any,                 catalina:       "1502fca0c423ced4903f48870f1788f4166a6cb69310bd82f76d5dba655c68ff"
    sha256 cellar: :any,                 mojave:         "64e9a2916188c3ccd8ae7459cf5e4ab3664c3d4cb8b764bed8314a5e95e141ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c3d838263937c5f836e95b21a161ce4f40549f20f635dfd4f48929cf9890af7"
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
