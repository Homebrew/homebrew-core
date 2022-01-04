class Overdrive < Formula
  desc "Bash script to download mp3s from the OverDrive audiobook service"
  homepage "https://github.com/chbrown/overdrive"
  url "https://github.com/chbrown/overdrive/archive/2.2.0.tar.gz"
  sha256 "5a4666ae75677acb90b593e6d31a12da0addefbdfeda679afcbd536c378500c2"
  license "MIT"
  head "https://github.com/chbrown/overdrive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9d056c2fed436d64d6269fa28f7cd821a75ee74bb7d8f3240b9509145b4a4c95"
  end

  depends_on "tidy-html5"
  uses_from_macos "curl"
  uses_from_macos "libressl"
  uses_from_macos "libxml2"

  def install
    bin.install "overdrive.sh" => "overdrive"
  end

  test do
    # A full run would require an authentic file, which can only be used once
    assert_match "Specified media file does not exist",
      shell_output("#{bin}/overdrive download fake_file.odm 2>&1", 2)
  end
end
