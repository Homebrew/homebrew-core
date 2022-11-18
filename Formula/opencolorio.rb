class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/v2.2.0.tar.gz"
  sha256 "81e3b6e0e432d20347b6396c376f9fbeceac31c2cbefe2882d83112a5b0a8123"
  license "BSD-3-Clause"
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "03ff1b5e5082e3955cb765598f1d13985839a213ceba7c82f4843ec78e57fdcc"
    sha256 cellar: :any,                 arm64_monterey: "e129f4cec79267cf32e6fab984e8e60d11c41c37ad0c1d2e3eab9fce0a74c02c"
    sha256 cellar: :any,                 arm64_big_sur:  "9c8d6cdc2eacb0147542713ce1715ca4603ab040815448f65732cd59fa441672"
    sha256 cellar: :any,                 ventura:        "7417bd8299ba95e3a682a6b50d094ad6139cb3196cae4ce0977d31683abaa827"
    sha256 cellar: :any,                 monterey:       "7bcddac6d9fec28ab52196a52cd2bce98351749644b3e0eadfae1756e17427f7"
    sha256 cellar: :any,                 big_sur:        "e98f8cad10e8a1a43481eb50d7e78acd5586a4dab9e956f8462a19d820617d49"
    sha256 cellar: :any,                 catalina:       "f1456ae9494b3de9f4ed34b9348f77ba87d7ebf4eac1aa3195b482720a47c0cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f301d10252d47ae478c45f757014c8ce8172bf87f67b232ef558d49b323ba266"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "little-cms2"
  depends_on "python@3.11"

  def install
    python3 = "python3.11"
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPYTHON=#{python3}
      -DPYTHON_EXECUTABLE=#{which(python3)}
    ]

    system "cmake", "-S", ".", "-B", "macbuild", *args, *std_cmake_args
    system "cmake", "--build", "macbuild"
    system "cmake", "--install", "macbuild"
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
