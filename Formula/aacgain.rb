class Aacgain < Formula
  desc "AAC-supporting version of mp3gain"
  homepage "https://aacgain.altosdesign.com/"
  # This server will autocorrect a 1.9 url back to this 1.8 tarball.
  # The 1.9 version mentioned on the website is pre-release, so make
  # sure 1.9 is actually out before updating.
  # See: https://github.com/Homebrew/homebrew/issues/16838
  url "https://aacgain.altosdesign.com/alvarez/aacgain-1.8.tar.bz2"
  sha256 "2bb8e27aa8f8434a4861fdbc70adb9cb4b47e1dfe472910d62d6042cb80a2ee1"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://aacgain.altosdesign.com/alvarez/"
    regex(/href=.*?aacgain[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c8bc457323db05d4c0ccd01187cc74d4367d5704953ced03883e7a806715b05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d09e7e41cb2fa9ab670f19797812669151b4b74c308ced6f00dfa8cfc83de0c"
    sha256 cellar: :any_skip_relocation, monterey:       "d057764a1d3416927fa973ac5d883f0a790a5f5fc425f39e1577bfae2513a2a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2adb8395d6c19e95733f54bf0665cca7f405f9d4489544d69d86704da3d545c"
    sha256 cellar: :any_skip_relocation, catalina:       "a8ec07d22279b4bdd471ee7a307e6d365a906432ef49533afeca2de53add8d55"
    sha256 cellar: :any_skip_relocation, mojave:         "a6d9e4d4f20311e0a91bdbc6f42ef8894e6a6b9f4d8290938d14f02868821c0d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "eda9c36cf9517c9f342031632b9fb38f77d8150cc2a7cf88b57e46f77395c96e"
    sha256 cellar: :any_skip_relocation, sierra:         "2d7ea587b06feb7ccb4f6dfaee3a6d7b329e041cc80af969afb8b5d1631997e8"
    sha256 cellar: :any_skip_relocation, el_capitan:     "b97aaaf19fee69734b4a29e22c498becaa94b3025a192a7ef8f1ecfb0a2ce87c"
    sha256 cellar: :any_skip_relocation, yosemite:       "5c01278c495e8a67b7af02f6355ac6a79ce6b4caa5148503346eb33e7d26b70a"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # aacgain modifies files in-place
    # See: https://github.com/Homebrew/homebrew/pull/37080
    cp test_fixtures("test.m4a"), "test.m4a"
    system bin/"aacgain", "test.m4a"
  end
end
