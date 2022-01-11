class Mtr < Formula
  desc "'traceroute' and 'ping' in a single tool"
  homepage "https://www.bitwizard.nl/mtr/"
  url "https://github.com/traviscross/mtr/archive/v0.95.tar.gz"
  sha256 "12490fb660ba5fb34df8c06a0f62b4f9cbd11a584fc3f6eceda0a99124e8596f"
  license "GPL-2.0-only"
  head "https://github.com/traviscross/mtr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4847c8258dc9313eed7d21bed16dfc35d201b5d5f3e71e9b7b2ac26f9c22d0c8"
    sha256 cellar: :any,                 arm64_big_sur:  "c3fc137c2d301be6228f09bce1bbeb0ca8b1686521c5682ed4c2c8c8fb115a3e"
    sha256 cellar: :any,                 monterey:       "1fb7173c99c636612d9c67057d1caf80bd3dd118214662bc46a4bef3292b026b"
    sha256 cellar: :any,                 big_sur:        "4e2466cde6fe93ab84bced0e3fe5639a2d36b524a36372ffd9fa73d64da40778"
    sha256 cellar: :any,                 catalina:       "9d81a6e600be3a19d5e8c7f3a5d88be22646ded4a30ce70f6eb5058fd7bef203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d9e7526b639e429052a90924d330e703c193db552537a684488391064d4ff20"
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
