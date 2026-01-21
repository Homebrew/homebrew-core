class Hackrf < Formula
  desc "Low cost software radio platform"
  homepage "https://github.com/greatscottgadgets/hackrf"
  url "https://github.com/greatscottgadgets/hackrf/releases/download/v2026.01.2/hackrf-2026.01.2.tar.xz"
  sha256 "71571bc8cfd26b3b8e1293efbd69fc8d94ce0baf802bd5af1e6d851d1c2cbc57"
  license "GPL-2.0-or-later"
  head "https://github.com/greatscottgadgets/hackrf.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2caae860ce83504c9f0191857c95980a31a7cfa3b6d91bb51db850cbd99beddd"
    sha256 cellar: :any,                 arm64_sequoia: "2cb9c4449d1667779010c4eecc8b14d6df71d909d24c606d70c18890e9841e1d"
    sha256 cellar: :any,                 arm64_sonoma:  "f3b7a1146710def25555bfd56b31d102a75e246b4180ac9a5c5dcca7cd14ad0c"
    sha256 cellar: :any,                 sonoma:        "fcb60c1ef17774d3c368a2e4780db00c798ba3b7891995b960f5d7a1069e2f68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32c11b1df3b6b9dedd3c25ac0686546edf6af13d7ef46b24569cdb6cbebe5f11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88c683bced291a32df8024568c12df694ef38b36a31f113f7cec10b80618b508"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "libusb"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    if OS.linux?
      args += %W[
        -DUDEV_RULES_GROUP=plugdev
        -DUDEV_RULES_PATH=#{lib}/udev/rules.d
      ]
    end

    system "cmake", "-S", "host", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "firmware-bin/"
  end

  test do
    shell_output("#{bin}/hackrf_transfer", 1)
  end
end
