class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/imageworks/OpenColorIO/archive/v1.1.1.tar.gz"
  sha256 "c9b5b9def907e1dafb29e37336b702fff22cc6306d445a13b1621b8a754c14c8"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/imageworks/OpenColorIO.git"

  bottle do
    cellar :any
    sha256 "41d69027763621bd23db83f3656587afbb90a456d6aab1d4429839a04a2bfdb8" => :big_sur
    sha256 "41140d26dbe70add3bece6d1dfc2b6a01b7ed1879c79c18e29eeefd66694b9db" => :catalina
    sha256 "f3b183e64cf41cc28273b9e0fe99013fd1bd4a7f3774f3be370423d04ac847da" => :mojave
    sha256 "4beea67e0c1400c1d82b1257bae9476e4f58fbab6a727f31161199b5dae4d3bc" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "little-cms2"
  depends_on "python@3.9"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_VERBOSE_MAKEFILE=OFF
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
