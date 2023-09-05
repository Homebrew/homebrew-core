class Mtr < Formula
  desc "'traceroute' and 'ping' in a single tool"
  homepage "https://www.bitwizard.nl/mtr/"
  url "https://github.com/traviscross/mtr/archive/v0.95.tar.gz"
  sha256 "12490fb660ba5fb34df8c06a0f62b4f9cbd11a584fc3f6eceda0a99124e8596f"
  license "GPL-2.0-only"
  head "https://github.com/traviscross/mtr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "83d9da1de6a03855e99e0db1f8060f196fda988b187493aaad8d15b039176644"
    sha256 cellar: :any,                 arm64_monterey: "832e28a80e1b4340c19c4dc3511504672ec03ff5cb54d7294e932b7d9aa80085"
    sha256 cellar: :any,                 arm64_big_sur:  "0e41037f1e0f662b87155307468c740594d2e16761e2b120a3086e0922c7bda5"
    sha256 cellar: :any,                 ventura:        "bbff689ff843d38238f2379af5022b4bd0848234a9bc4e0a79fae8669510cc8b"
    sha256 cellar: :any,                 monterey:       "8388e7af1b04e7749ffa93b3a9479df605cbe16d7a88c02625ecd229e36043f9"
    sha256 cellar: :any,                 big_sur:        "bb07a178a739fc8c8a15fc7645efc7fe749b81663752bcd66cb1efcd47217371"
    sha256 cellar: :any,                 catalina:       "7ee23cbae756e561d02a0ffe3b32476cd635b54f70240a937c43e7608c27766d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b2707211f207742525047d68e4b3e870b524f093ea8ce8f76b8fb3999e6f8d5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"

  def install
    # Fix UNKNOWN version reported by `mtr --version`.
    inreplace "configure.ac",
              "m4_esyscmd([build-aux/git-version-gen .tarball-version])",
              version.to_s

    # We need to add this because nameserver8_compat.h has been removed in Snow Leopard
    ENV["LIBS"] = "-lresolv"
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-glib
      --without-gtk
    ]
    system "./bootstrap.sh"
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      mtr requires root privileges so you will need to run `sudo mtr`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    # We patch generation of the version, so let's check that we did that properly.
    assert_match "mtr #{version}", shell_output("#{sbin}/mtr --version")
    # mtr will not run without root privileges
    assert_match "Failure to open", shell_output("#{sbin}/mtr google.com 2>&1", 1)
    # Check that the `--json` flag is recognised.
    assert_match "Failure to open", shell_output("#{sbin}/mtr --json google.com 2>&1", 1)
  end
end
