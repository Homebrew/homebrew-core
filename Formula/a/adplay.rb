class Adplay < Formula
  desc "Command-line player for OPL2 music"
  homepage "https://adplug.github.io"
  url "https://github.com/adplug/adplay-unix/releases/download/v1.9/adplay-1.9.tar.bz2"
  sha256 "949b2618092a3aae5c278a98dfa3231130ef35a791b3afcaa0ebe45443ce82c8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "09db45033118afa94298a58b3514d0265fb3f11c90341760e20899663ccc4fd8"
    sha256 cellar: :any,                 arm64_sequoia: "967f04bd760c74ad7d1f31dc4e4baffeabe9db557959465fd6d27a9834a42aa1"
    sha256 cellar: :any,                 arm64_sonoma:  "20299de36acaf9dcbba5b1b827031a716014d6b7fd8846cf17234e614da0376a"
    sha256 cellar: :any,                 sonoma:        "62f0e81f88d53e2f0882ff204ef39ac34398c59111d90b1a86e1c4903710ef0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "beeaca960d641fa18e2386ef83ab7ab2df2b030aa683e6eb724eecb3251d09c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5802a081b95a8a5610e8c27fe5100048e4eb89ca17ffef6fcf07fadda24e671c"
  end

  head do
    url "https://github.com/adplug/adplay-unix.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "adplug"
  depends_on "libbinio"
  depends_on "sdl2"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    # SDL output works better than libao
    system "./configure", "--disable-output-ao",
                          "--disable-silent-rules",
                          *std_configure_args
    system "make", "install"
  end

  test do
    resource "test_file" do
      url "https://github.com/adplug/adplug/raw/b5fe1a77a521d8072a95bd5a63450a55365505e9/test/testmus/TheAlibi.d00"
      sha256 "070bcb87f935d38e8561cb72228af4067c8f4f02a51d84437208d9f830055e2e"
    end

    assert_includes(shell_output("#{bin}/adplay --version"), "AdPlay/UNIX")

    resource("test_file").stage do
      output = shell_output("#{bin}/adplay TheAlibi.d00 --output=disk --device=TheAlibi.wav 2>&1")
      assert_match "EdLib packed (version 1)", output

      output = shell_output("/usr/bin/file TheAlibi.wav")
      assert_match "TheAlibi.wav: RIFF (little-endian) data, WAVE audio", output
    end
  end
end
