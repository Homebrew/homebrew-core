class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/refs/tags/v3.7.20.tar.gz"
  sha256 "7264d705ff53185f0847c69abdfce072779c0b907257e087a6372c7608108f65"
  license all_of: [
    "BSD-4-Clause", # AFFLIB 2.0a14 and before
    :public_domain, # contributions after 2.0a14
  ]
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "af52cd782cf1b09fa70e6aa3b44579058589a7cbec2f17a93186eec3590a0d12"
    sha256 cellar: :any,                 arm64_sonoma:  "8e84ddb30d99b5c56442a283864d27424fba3ec1e918219c0fca34c64f040973"
    sha256 cellar: :any,                 arm64_ventura: "b311a78fdc13c779b83bf5fa6acdab8c1c8393d66ff6d161530a634502533144"
    sha256 cellar: :any,                 sonoma:        "e8b9a5c531f2bcbff5a706b6c592a764e58cb3d81143dcc22309166f97734277"
    sha256 cellar: :any,                 ventura:       "a039726658443649798f2058fc46b37250f9dd7d86ce29f453f149be2b464ac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6c3fd05bc590c7920e9c78895e931dea3e61ead38101fe87e483dc268f951e3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "openssl@3"
  depends_on "python@3.13"
  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  # Backport commits for regenerated pyaff.c to fix build with Python 3.12.
  # Remove in the next release.
  patch do
    url "https://github.com/sshock/AFFLIBv3/commit/e465b771c11a975e69bd3d89c11dbc15b6c3c951.patch?full_index=1"
    sha256 "833e168baaddbf243d8a58cd370998c47745fe6bd6d1e4a912bd00df05fb28aa"
  end
  patch do
    url "https://github.com/sshock/AFFLIBv3/commit/4309b86f4a5e9beab4c41e16a7a971f79b56f644.patch?full_index=1"
    sha256 "48f0852729ff33f53d8f2a6aa135ef7459ce481d2d34a5fa27068edd3a883401"
  end
  patch do
    url "https://github.com/sshock/AFFLIBv3/commit/01210f488410a23838c54fcc22297cf08ac7de66.patch?full_index=1"
    sha256 "7ad16951841f278631f11432ba7ec2284c317367bb5f28816eb9a6748be1065a"
  end

  def python3
    which("python3.13")
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-fuse",
                          "--disable-python",
                          "--disable-silent-rules",
                          "--enable-s3",
                          *std_configure_args
    system "make", "install"

    # We install Python bindings with pip rather than `./configure --enable-python` to avoid
    # managing Setuptools dependency and modifying Makefile to work around our sysconfig patch.
    # As a side effect, we need to imitate the Makefile and provide paths to headers/libraries.
    ENV.append_to_cflags "-I#{include}"
    ENV.append "LDFLAGS", "-L#{lib}"

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./pyaff"
  end

  test do
    system bin/"affcat", "-v"

    system python3, "-c", "import pyaff"
  end
end
