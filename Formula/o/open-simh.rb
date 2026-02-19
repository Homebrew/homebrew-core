class OpenSimh < Formula
  desc "Multi-system computer simulator"
  homepage "https://opensimh.org/"
  url "https://github.com/open-simh/simh/archive/refs/tags/v3.12-3.tar.gz"
  sha256 "9d0370c79e8910fa1cd2b19d23885bfaa5564df86101c40481dd9b6e64593b18"
  license "MIT"
  head "https://github.com/open-simh/simh.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-\d+)?)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "14ca95542e0080680f5a68363b5a3cf88faebd66d2a85e0820048e4019a5b38c"
    sha256 cellar: :any,                 arm64_sequoia: "25571e5341da2b41ee773893e974a462101e920cc7d92b27bd789ccd2f027989"
    sha256 cellar: :any,                 arm64_sonoma:  "0d4672a79f07348b1727f6ced8a944a6bfe0ebdb5f3128c221738568c39077c3"
    sha256 cellar: :any,                 sonoma:        "647307fe3b6a161e7764656a93f21c70888d85cb9ad4cbb262aba4913f839247"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "304120ac24e399c353405da304d1fcd76751342f2cfbf262f5d1f558bec6b96c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de06ffb145c4dc46c4b3535be6a5b99ac8ddec04cd7cd914ca1f8b0ccf595104"
  end

  depends_on "libpng"
  depends_on "vde"

  uses_from_macos "libedit"
  uses_from_macos "libpcap"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "nova-fairwinds", because: "both install `nova` binaries"
  conflicts_with "sigma-cli", because: "both install `sigma` binaries"

  def install
    if OS.linux?
      ENV.append_to_cflags "-fcommon"
      inreplace "makefile", "+= /usr/lib/", "+= /usr/lib/ #{HOMEBREW_PREFIX}/lib/"
    end
    system "make", "GCC=#{ENV.cc}", "CFLAGS_G=#{ENV.cflags}", "all"

    bin.install Dir["BIN/*"]
    doc.install Dir["doc/*"]
    Dir["**/*.txt"].each do |f|
      (doc/File.dirname(f)).install f
    end
    (pkgshare/"vax").install Dir["VAX/*.{bin,exe}"]
  end

  test do
    assert_match "Goodbye", pipe_output("#{bin}/altair", "exit\n", 0)
  end
end
