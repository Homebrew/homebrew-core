class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://github.com/phaag/nfdump"
  url "https://github.com/phaag/nfdump/archive/refs/tags/v1.7.6.tar.gz"
  sha256 "2d25220d7a48f57ba65f228fb5d2eb4d2a0ab2b352a037ed6249b39cf68c1b9a"
  license "BSD-3-Clause"
  head "https://github.com/phaag/nfdump.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "70ed181f2802d7cef5d7f2b1bd84f77230d583e2c9e3e10d3258ee467f38000d"
    sha256 cellar: :any,                 arm64_sonoma:  "7f23722b7a4f8181d40180fb42841a1ebd86230b9322cd050acbaea2ff90db2d"
    sha256 cellar: :any,                 arm64_ventura: "424411e0768b194b1a4f3bc6d8e82b672cb3b4a6157e8f7aeeeaf200c4fcad46"
    sha256 cellar: :any,                 sonoma:        "7b3e11f6b9a6d47040b63dbb735a7a507159e9c2aa285c54eed261850222657c"
    sha256 cellar: :any,                 ventura:       "2f1facb7bf72b6f485cbf93893eef1900d53390e818dbd9058939d44c897d88c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "076f868834aad8744276bf4188882d734cd95a4a385bd508fef97ee28b427727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb8802b9818c72c36612ab68ee6058611588998eb2e2eb570608acfa1a05086d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "libpcap"

  def install
    system "./autogen.sh"
    system "./configure", "--enable-readpcap", "LEXLIB=", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"nfdump", "-Z", "host 8.8.8.8"
  end
end
