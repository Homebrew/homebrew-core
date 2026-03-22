class Httperf < Formula
  desc "Tool for measuring webserver performance"
  homepage "https://github.com/httperf/httperf"
  license "GPL-2.0-or-later"
  revision 2

  stable do
    url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/httperf/httperf-0.9.0.tar.gz"
    sha256 "e1a0bf56bcb746c04674c47b6cfa531fad24e45e9c6de02aea0d1c5f85a2bf1c"

    # Upstream patch for OpenSSL 1.1 compatibility
    # https://github.com/httperf/httperf/pull/48
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/httperf/openssl-1.1.diff"
      sha256 "69d5003f60f5e46d25813775bbf861366fb751da4e0e4d2fe7530d7bb3f3660a"
    end
  end

  # Until the upstream GitHub repository creates a new release (something after
  # 0.9.0), we're unable to create a check that can identify new versions.
  livecheck do
    skip "No version information available to check"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "71e96d3ce855016759a6c5004a232db5f8d63883bc1760356566a0b8484d6a4d"
    sha256 cellar: :any,                 arm64_sequoia:  "777ac05c7372517913a1dc06a7cfa1499480ed89708baf56d57749bfaf9b3375"
    sha256 cellar: :any,                 arm64_sonoma:   "4f3dbaee84b9ecec246b11f1da959850d5ec283d28dd0ec11e40c7d93975734e"
    sha256 cellar: :any,                 arm64_ventura:  "cf626f3e9d749e395728ce1ca02b1441be6321989841a0b1135baef10455b739"
    sha256 cellar: :any,                 arm64_monterey: "a6976f04d98a5195075909f77587f0c113ed94389a49ab1ff4ddfc263c14c3ea"
    sha256 cellar: :any,                 arm64_big_sur:  "e8a25cd3891631f61aaaf69682a952ceaa5e680559defd48a0de3eaebe1f1519"
    sha256 cellar: :any,                 sonoma:         "3ca6eec51c2712c64eb58bab12064953826af672d843171672f6d60fb034df0c"
    sha256 cellar: :any,                 ventura:        "3f61658586cbdac24c810c9b201d8054f9f800046a7ec1b6754e82e49be64244"
    sha256 cellar: :any,                 monterey:       "72bdd969d2e88750ea3827860143f05756fb0da35f9ce04d185ed9de0f42791f"
    sha256 cellar: :any,                 big_sur:        "a77143c2960957c7b998ef8259f23f7252264e297c1f8a7f812c7712eec756f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1b14593cb779357511b91b27d4de352324c2eafa8390353cdc7e8332ca230443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da0a7ad0ca9b357505cc3c26fa174dd7c4f289e2054e654eb82e2678aad8dc74"
  end

  head do
    url "https://github.com/httperf/httperf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    # idleconn.c:164:28: error: passing argument 2 of ‘connect’ from incompatible pointer type
    ENV.append_to_cflags "-Wno-error=incompatible-pointer-types"

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"httperf", "--version"
  end
end
