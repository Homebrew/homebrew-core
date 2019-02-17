class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "http://opencolorio.org/"
  url "https://github.com/imageworks/OpenColorIO/archive/v1.1.0.tar.gz"
  sha256 "228589879e1f11e455a555304007748a8904057088319ebbf172d9384b93c079"
  head "https://github.com/imageworks/OpenColorIO.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "32fcad955accfc44df863e8ac4cbaba9e5f50efc49647c697d80bd8fcac8d598" => :mojave
    sha256 "d4fa4ba36acdb1b7de46d55f41d4882409178819fbcf090a01e500db417c07b4" => :high_sierra
    sha256 "81c5011ac096c99112229d1ca5a905dda9340dc0612ac45d412fc92d0213fda3" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "little-cms2"
  depends_on "python@2"

  def install
    args = std_cmake_args
    args << "-DCMAKE_VERBOSE_MAKEFILE=OFF"

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
        http://opencolorio.org/installation.html#environment-variables

      You will require a config for OCIO to be useful. Sample configuration files
      and reference images can be found at:
        http://opencolorio.org/downloads.html
    EOS
  end

  test do
    assert_match "validate", shell_output("#{bin}/ociocheck --help", 1)
  end
end
