class Overdrive < Formula
  desc "Bash script to download mp3s from the OverDrive audiobook service"
  homepage "https://github.com/chbrown/overdrive"
  url "https://github.com/chbrown/overdrive/archive/2.3.3.tar.gz"
  sha256 "ebd1ddb07fbf8a0fa7961eeb37f13a4a9d15857dae5426cb087e9ecc77a4d452"
  license "MIT"
  head "https://github.com/chbrown/overdrive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c4425d8175d084f1710699325007c550621e67198e2faa369eb87687cbea0442"
  end

  depends_on "tidy-html5"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "openssl@1.1" # for openssl (non keg-only)
    depends_on "util-linux" # for uuidgen
  end

  def install
    bin.install "overdrive.sh" => "overdrive"
  end

  test do
    # A full run would require an authentic file, which can only be used once
    assert_match "Specified media file does not exist",
      shell_output("#{bin}/overdrive download fake_file.odm 2>&1", 2)
  end
end
