class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/imageworks/OpenColorIO/archive/v2.0.0.tar.gz"
  sha256 "b407afcbcaecad8409545857796b9b6e27b0be0c85f2b9e7aa7d251bdc3a4416"
  license "BSD-3-Clause"
  head "https://github.com/imageworks/OpenColorIO.git"

  bottle do
    sha256 cellar: :any, big_sur:  "71158ec7ad5d639725b0fff7c959c917ef487b57a5ab86a50be513f37bc2de27"
    sha256 cellar: :any, catalina: "ed6222a9cd879320f401346aef14e0c2bf32f530c7deb6738376923d98474e10"
    sha256 cellar: :any, mojave:   "d4168fbcacc162d72f1ed558d3e0aa19efdd93ffd49b24078d6f9abb998a545e"
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
