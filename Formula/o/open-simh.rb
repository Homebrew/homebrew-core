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
    sha256 cellar: :any,                 arm64_tahoe:    "ce5bc721d70a624ffd4f0a85a667c83f2c86158384785dc29741cfd958aacd44"
    sha256 cellar: :any,                 arm64_sequoia:  "848fae7d7b6b38629ba56cee3fe71d9d622ae73a15f6da231fe185ebf7250607"
    sha256 cellar: :any,                 arm64_sonoma:   "43567e394094f3435e761a4114a421c0488f5af137ce9b4d8aff87d75b485fa1"
    sha256 cellar: :any,                 arm64_ventura:  "ee7d22345190d2009472b2233bb6c974790f5b38331877ec647be5971f403ae6"
    sha256 cellar: :any,                 arm64_monterey: "134f1dff238a06523a66039d07f44493460b8b3cdc22b652cd2a6f5e64180e00"
    sha256 cellar: :any,                 sonoma:         "086bbb15c8872e69967c8b5c600ae22a5389fd37e4e3a7fcc54cabae7cbe4cc6"
    sha256 cellar: :any,                 ventura:        "28c9c12e56fea289d1d1803752e517f162e4692d76a24f33d7edc09288a02915"
    sha256 cellar: :any,                 monterey:       "c68fb8a31e1b55c2a5aa6a907df37ab80ce8672573283adf394906720309a743"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ed4ccf5fd723feaf76ffe1d8ee55828a51773f71d9afa67826751ad456a79109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15e1de5c0c7a5ac581db904d311b660667ea9937cca2745c8b225856b5454208"
  end

  depends_on "libpng"
  depends_on "pcre"
  depends_on "vde"

  uses_from_macos "libedit"
  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  conflicts_with "nova-fairwinds", because: "both install `nova` binaries"
  conflicts_with "sigma-cli", because: "both install `sigma` binaries"

  def install
    ENV.append_to_cflags "-Os -fcommon" if OS.linux?
    inreplace "makefile" do |s|
      s.gsub! "+= /usr/lib/", "+= /usr/lib/ #{HOMEBREW_PREFIX}/lib/" if OS.linux?
      s.gsub! "GCC = gcc", "GCC = #{ENV.cc}"
      s.gsub! "= -O2", "= #{ENV.cflags}"
    end
    system "make", "all"

    bin.install Dir["BIN/*"]
    doc.install Dir["doc/*"]
    Dir["**/*.txt"].each do |f|
      (doc/File.dirname(f)).install f
    end
    (pkgshare/"vax").install Dir["VAX/*.{bin,exe}"]
  end

  test do
    assert_match(/Goodbye/, pipe_output("#{bin}/altair", "exit\n", 0))
  end
end
