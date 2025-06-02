class Diary < Formula
  desc "Text-based journaling program"
  homepage "https://diary.p0c.ch"
  url "https://code.in0rdr.ch/diary/archive/diary-v0.16.tar.gz"
  sha256 "9140762d44251ebce08d5ae45878a30fc9c35dcdd98fe64da618cdd2062552dc"
  license "MIT"

  livecheck do
    url "https://code.in0rdr.ch/diary/archive/"
    regex(/href=.*?diary[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d646d24e89a8eb7dce47ec54e42214c09010d070e893c29e2a55427cfe7e846b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30581920926485a47ab45731defce3acf5dd1c2366e4551a9b25952d03c171ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b4f3a31788c1181823adcb3236ac4353eb442e293f39e320d9af8706cc6a098"
    sha256 cellar: :any_skip_relocation, sonoma:        "48d82219a584be1acb7add11dce24b2258c38baf4b5e39f7b3afcbdb4a7c3976"
    sha256 cellar: :any_skip_relocation, ventura:       "609b1792141d8537dfef086956db2cd0c81815ef038aae86bbb31343c10bbfe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9b9443c49ef95c8a613df3d244a14db2285fce87537931f53c05d5c527c3159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9916f762d45e4d351e2d678b938d05a5d4ce2ac7a366488706d2c3de3627a9ca"
  end

  depends_on "pkgconf" => :build

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  def install
    system "make"
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}", "install"
  end

  test do
    # Test version output matches the packaged version
    assert_match version.to_s, shell_output("#{bin}/diary -v")

    # There is only one configuration setting which is required to start the
    # application, the diary directory.
    #
    # Test DIARY_DIR environment variable
    assert_match "The directory 'na' does not exist", shell_output("DIARY_DIR=na #{bin}/diary 2>&1", 2)
    # Test diary dir option
    assert_match "The directory 'na' does not exist", shell_output("#{bin}/diary -d na 2>&1", 2)
    # Test missing diary dir option
    assert_match "The diary directory must be provided as (non-option) arg, " \
                 "`--dir` arg,\nor in the DIARY_DIR environment variable, " \
                 "see `diary --help` or DIARY(1)\n", shell_output("#{bin}/diary 2>&1", 1)
  end
end
