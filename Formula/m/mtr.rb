class Mtr < Formula
  desc "'traceroute' and 'ping' in a single tool"
  homepage "https://www.bitwizard.nl/mtr/"
  url "https://github.com/traviscross/mtr/archive/refs/tags/v0.96.tar.gz"
  sha256 "73e6aef3fb6c8b482acb5b5e2b8fa7794045c4f2420276f035ce76c5beae632d"
  # Main license is GPL-2.0-only but some compatibility code is under other licenses:
  # 1. portability/queue.h is BSD-3-Clause
  # 2. portability/error.* is LGPL-2.0-only (only used on macOS)
  # 3. portability/getopt.* is omitted as unused
  license all_of: ["GPL-2.0-only", "BSD-3-Clause", "LGPL-2.0-only"]
  head "https://github.com/traviscross/mtr.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e895fc7ed39c99111d74a2ca15aeaee2ff99c4106af7517f60a6accc71560eec"
    sha256 cellar: :any,                 arm64_sequoia: "a7bacefb19840814841941c74a3ac93d8e0e5355b09c471e3b76dec702315fc3"
    sha256 cellar: :any,                 arm64_sonoma:  "ab39214cf72c697c0e436035efbf4e1b8b846ebec5f390e1ab39949740adb210"
    sha256 cellar: :any,                 arm64_ventura: "160496478cf39459cfdb9a39b32408cddb62797a7f5c7b511b21d0f243daf2e6"
    sha256 cellar: :any,                 sonoma:        "f89057c3a1fe1c6ed781ff12794f8313e1aa8b40c6fb8c921d30f4b16b4ec1fe"
    sha256 cellar: :any,                 ventura:       "4dac9630dd7d0fd91fdf2ab472c515235f25969d6de0d6f0773bdd56989c2312"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55386202173e44242ea3fc0cab0f6d3e0a82e958661470c6a554580631a25cc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e5bc25c0c9a1c56b8d0f5b4f1276f629a283e50f0fd901ecfe8eb7e2c76f43f"
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
