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

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d8fe01051dd20bebd918d8d4e0634218121d1a9b3b0be2e5830cdf24bc1d9fd5"
    sha256 cellar: :any,                 arm64_big_sur:  "ce70f4a494445f8afde960c4ceea838e48b98fcf4c4d9513f705afae83193433"
    sha256 cellar: :any,                 monterey:       "5154065582dbae8bf645834ccabc9b878a77dc21d5a85d307366d78b6ee7ed91"
    sha256 cellar: :any,                 big_sur:        "08aba9012402bf7611ddc2fb0f6e0dfcb31c97ce067dd83d6ae73830b5d30aeb"
    sha256 cellar: :any,                 catalina:       "802d07a3f0948bf0f3a60bb174b1ee56e028b4b24f9eb121e9f90e5926e689c0"
    sha256 cellar: :any,                 mojave:         "8ce7e1320ee7e3d10764ace6801eecb28cac49dadef648de79258e1d254da06c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8984abcb585701a695fedbebd0c13cd61b08b95240c22485c75e2aac1575c57a"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
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
    system "#{bin}/statgrab"
  end
end
