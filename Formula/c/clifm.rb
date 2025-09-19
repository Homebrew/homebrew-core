class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://github.com/leo-arch/clifm/archive/refs/tags/v1.26.tar.gz"
  sha256 "2f5e5e2412307ea9e4e836b441785b325de58e12150629e81364f4da9adf4f01"
  license "GPL-2.0-or-later"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "89f24d03d95bf904213b905952e6a06268d123afb0f09f0cf01cb4ae5dc4dc37"
    sha256 arm64_sequoia: "7be7796709f7ca466992db05d392ef3d3047f00137e1707809936cb6441a2b8d"
    sha256 arm64_sonoma:  "22b436b4f4823a7c719d5d25af622be085b534b4dd324880ae5bb7859714e76a"
    sha256 arm64_ventura: "3b674877102f21320b79025e5d6c7ccb0670cd9b6316c50f8a4393d03f8ed9ec"
    sha256 sonoma:        "017db21defcd427c887492c6dfe57c5c16addbb3ac08b3942ff944b3635a1d9d"
    sha256 ventura:       "e9ace98ae488fa617015fe260348fc1514d95b0a643544addef2c8591e258304"
    sha256 arm64_linux:   "a460959530ae1d88ccd4c978e77dd32709077fad72a67be6fdab60782d655058"
    sha256 x86_64_linux:  "2e1ae652bd0acd2772101eb67e14f1c9ced01e17586c4b453ec5ac69bd25da31"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "libmagic"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "acl"
    depends_on "libcap"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # fix `clifm: dumb: Unsupported terminal.` error
    ENV["TERM"] = "xterm"

    output = shell_output("#{bin}/clifm nonexist 2>&1", 2)
    assert_match "clifm: 'nonexist': No such file or directory", output
    assert_match version.to_s, shell_output("#{bin}/clifm --version")
  end
end
