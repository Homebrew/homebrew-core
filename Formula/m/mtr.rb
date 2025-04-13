class Mtr < Formula
  desc "'traceroute' and 'ping' in a single tool"
  homepage "https://www.bitwizard.nl/mtr/"
  url "https://github.com/traviscross/mtr/archive/refs/tags/v0.95.tar.gz"
  sha256 "12490fb660ba5fb34df8c06a0f62b4f9cbd11a584fc3f6eceda0a99124e8596f"
  # Main license is GPL-2.0-only but some compatibility code is under other licenses:
  # 1. portability/queue.h is BSD-3-Clause
  # 2. portability/error.* is LGPL-2.0-only (only used on macOS)
  # 3. portability/getopt.* is omitted as unused
  license all_of: ["GPL-2.0-only", "BSD-3-Clause", "LGPL-2.0-only"]
  head "https://github.com/traviscross/mtr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "de2a8c8ebe004fa34eb74e44a23eda5371a0b00d794c31541369afc9383dcb59"
    sha256 cellar: :any,                 arm64_sonoma:   "d1d03f6a4f9a9e49321d656b787d4e53f1f6acad08384d68bb4ad8199bf1626e"
    sha256 cellar: :any,                 arm64_ventura:  "83d9da1de6a03855e99e0db1f8060f196fda988b187493aaad8d15b039176644"
    sha256 cellar: :any,                 arm64_monterey: "832e28a80e1b4340c19c4dc3511504672ec03ff5cb54d7294e932b7d9aa80085"
    sha256 cellar: :any,                 arm64_big_sur:  "0e41037f1e0f662b87155307468c740594d2e16761e2b120a3086e0922c7bda5"
    sha256 cellar: :any,                 sonoma:         "fad686ff163def04ca773130a81921c8498606f072ff7af37c62463e8aaf5412"
    sha256 cellar: :any,                 ventura:        "bbff689ff843d38238f2379af5022b4bd0848234a9bc4e0a79fae8669510cc8b"
    sha256 cellar: :any,                 monterey:       "8388e7af1b04e7749ffa93b3a9479df605cbe16d7a88c02625ecd229e36043f9"
    sha256 cellar: :any,                 big_sur:        "bb07a178a739fc8c8a15fc7645efc7fe749b81663752bcd66cb1efcd47217371"
    sha256 cellar: :any,                 catalina:       "7ee23cbae756e561d02a0ffe3b32476cd635b54f70240a937c43e7608c27766d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "dd12499c2fd410879561de9ffbc0a47393cb2b370d8889091b2b751678f32411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b2707211f207742525047d68e4b3e870b524f093ea8ce8f76b8fb3999e6f8d5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "jansson"

  def install
    # Fix UNKNOWN version reported by `mtr --version`.
    inreplace "configure.ac",
              "m4_esyscmd([build-aux/git-version-gen .tarball-version])",
              version.to_s

    args = %W[
      --disable-silent-rules
      --without-glib
      --without-gtk
      --with-bashcompletiondir=#{bash_completion}
    ]
    system "./bootstrap.sh"
    system "./configure", *args, *std_configure_args
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
    if OS.mac?
      # mtr will not run without root privileges
      assert_match "Failure to open", shell_output("#{sbin}/mtr google.com 2>&1", 1)
      assert_match "Failure to open", shell_output("#{sbin}/mtr --json google.com 2>&1", 1)
    else
      # mtr runs but won't produce useful output without extra privileges
      assert_match "2.|-- ???", shell_output("#{sbin}/mtr google.com 2>&1")
      assert_match '"dst": "google.com"', shell_output("#{sbin}/mtr --json google.com 2>&1")
    end
  end
end
