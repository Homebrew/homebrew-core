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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "67df29be666984944e37f97342ad07fc1461f5cbe01c0cb8f42bd922ce052274"
    sha256 cellar: :any,                 arm64_sequoia: "3bd5b3ff10236b2b6f4c2cd999ccb7e2153a88d016d6481ac78cbd29e3eac677"
    sha256 cellar: :any,                 arm64_sonoma:  "7cef924d844b2c9292b3bac8b15984b75dda71442d37bfd68a0a85c2ea6df235"
    sha256 cellar: :any,                 sonoma:        "04fcdedce9b84cb20f27ef9cfdf872125cbc372f051a9260e0bd9b986a2f339d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45c1d47467c0db6b528fe3e51e07852409bf7a69d752126ecb3caa31224e60df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47f761326158b79077aa6838502fc6186f111da84c6e98425f8722f0165ec5c1"
  end

  depends_on "libpng"
  depends_on "vde"

  uses_from_macos "libedit"
  uses_from_macos "libpcap"
  uses_from_macos "zlib"

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
