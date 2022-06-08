class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/v2.1.2.tar.gz"
  sha256 "6c6d153470a7dbe56136073e7abea42fa34d06edc519ffc0a159daf9f9962b0b"
  license "BSD-3-Clause"
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f50d5ba3977c39c7675f9a47c6e6e8a94dde8ffaa0eff80e0a4f3f85ac60fc83"
    sha256 cellar: :any,                 arm64_big_sur:  "a12191e6238cf29395345d5d1be49d52912a1e6a6066baa11558184122df6d31"
    sha256 cellar: :any,                 monterey:       "e909973e5bb4f73da7feb23846bc2f1ac5dbe9de58c7f1cdbcb5cea375faac15"
    sha256 cellar: :any,                 big_sur:        "d5569167550905603f4512ed476af45f9803d292f5de1b122e509854d24c43a7"
    sha256 cellar: :any,                 catalina:       "b12394d8d4e9180dfcb7bb943d1d0fa25546f86f82b50863be7566320b6de9b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "919b027f1ebe994bf1e43f264a361b70183e28200e10340fc6fb56d7978e6ece"
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
