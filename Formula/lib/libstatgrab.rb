class Libstatgrab < Formula
  desc "Provides cross-platform access to statistics about the system"
  homepage "https://libstatgrab.org/"
  url "https://github.com/libstatgrab/libstatgrab/releases/download/LIBSTATGRAB_0_92_1/libstatgrab-0.92.1.tar.gz"
  mirror "https://www.mirrorservice.org/pub/i-scream/libstatgrab/libstatgrab-0.92.1.tar.gz"
  sha256 "5688aa4a685547d7174a8a373ea9d8ee927e766e3cc302bdee34523c2c5d6c11"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :stable
    regex(/^LIBSTATGRAB[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "22b0adf587cf3abc79ab1bf64cce1f5fa418cc2516981fe4db0ea33cd54ce274"
    sha256 cellar: :any,                 arm64_sequoia:  "666c2bc394e1533387652704633873d2ad01670f67503bc8dbf8c66e6b53e4ac"
    sha256 cellar: :any,                 arm64_sonoma:   "896492a8a90fe3c6f335ad15785a8fb7521b1200c3e88d1989136a17eebdab60"
    sha256 cellar: :any,                 arm64_ventura:  "7c52741c5bc27ba569e9d97c89ab5258f51f0b66c46e678f35fc8770f0fa6655"
    sha256 cellar: :any,                 arm64_monterey: "d8fe01051dd20bebd918d8d4e0634218121d1a9b3b0be2e5830cdf24bc1d9fd5"
    sha256 cellar: :any,                 arm64_big_sur:  "ce70f4a494445f8afde960c4ceea838e48b98fcf4c4d9513f705afae83193433"
    sha256 cellar: :any,                 sonoma:         "0a4526da3d4c86b1ceaa98ca701ddb3a6a34db17643a6b75c129cda9a6bde856"
    sha256 cellar: :any,                 ventura:        "35cc23ef8a82b0b187d227e801d66aec5f561464c353234ee5aef30b3894c0d4"
    sha256 cellar: :any,                 monterey:       "5154065582dbae8bf645834ccabc9b878a77dc21d5a85d307366d78b6ee7ed91"
    sha256 cellar: :any,                 big_sur:        "08aba9012402bf7611ddc2fb0f6e0dfcb31c97ce067dd83d6ae73830b5d30aeb"
    sha256 cellar: :any,                 catalina:       "802d07a3f0948bf0f3a60bb174b1ee56e028b4b24f9eb121e9f90e5926e689c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "20fa34ce8b897ffc1d9ef30d7c1636fb86d2b1299dad7d730a000f47ff4691cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8984abcb585701a695fedbebd0c13cd61b08b95240c22485c75e2aac1575c57a"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"statgrab"
  end
end
