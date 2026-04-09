class Darkstat < Formula
  desc "Network traffic analyzer"
  homepage "https://unix4lyfe.org/darkstat/"
  url "https://github.com/emikulic/darkstat/archive/refs/tags/3.0.722.tar.gz"
  sha256 "5c8e66d4c478b6d7e58f4c842823a09125509bf6851017ff70e32b32ce95b01b"
  license all_of: ["BSD-4-Clause-UC", "GPL-2.0-only", "GPL-3.0-or-later", "X11"]
  head "https://github.com/emikulic/darkstat.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cfccbabe435d29d446814260e1b72630779beffead9eadd470af5afe9312693"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23eb83cba8e48928c0cd41969bbdf96ccc3fb71a4acc4c1c66ad335fd40ab9f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57bdcd3fd262d6d578db0c52953ef9d6f4584d0b912bde9a9739535382c3f323"
    sha256 cellar: :any_skip_relocation, sonoma:        "381397a54498e721b83ac4367f14777baa722d28bab6ec8e319888a7047719af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b34c601064b8dc71f66617d12b0e69408dd78a7db0c4a83d58851dd33293e7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8011056a0e2efc7eb4552ef971ae53c912c08609e1a91d92e2daf4c4858e728c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "libpcap"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Patch reported to upstream on 2017-10-08
  # Work around `redefinition of clockid_t` issue on 10.12 SDK or newer
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/darkstat/clock_gettime.patch"
    sha256 "001b81d417a802f16c5bc4577c3b840799511a79ceedec27fc7ff1273df1018b"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"darkstat", "--verbose", "-r", test_fixtures("test.pcap")
  end
end
