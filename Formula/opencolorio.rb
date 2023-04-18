class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/v2.2.1.tar.gz"
  sha256 "36f27c5887fc4e5c241805c29b8b8e68725aa05520bcaa7c7ec84c0422b8580e"
  license "BSD-3-Clause"
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "24e90581137d74ea93eea49a901df620a6b6e2701b0c0093d2a11536e52759a4"
    sha256 cellar: :any,                 arm64_monterey: "53198ac5f3461fb2548af12babb164d6693749b2023cf064eb2f5ffd1b71ecc6"
    sha256 cellar: :any,                 arm64_big_sur:  "d074e606a1c3fec28b0d692c03aa88238074359ad47d56cf06887d9101b564cb"
    sha256 cellar: :any,                 ventura:        "c3c4653825daa64ab29a454b7fb03407f2b92b0982a4a77e44fbb7e5370c7842"
    sha256 cellar: :any,                 monterey:       "6ef1226d44426a9159f66d1ee39cbbc9b7954dda1c6f5167ae77e67bdc4a4c3d"
    sha256 cellar: :any,                 big_sur:        "233b55833ab1b80ab8a7265ac31fe2f63a48b83f885ee0128d00443ff213bf9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14827e687761b816cbeaab2471aba1791d23b080b8525123cbe09e4e78c23491"
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
