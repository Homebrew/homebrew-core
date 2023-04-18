class Overdrive < Formula
  desc "Bash script to download mp3s from the OverDrive audiobook service"
  homepage "https://github.com/chbrown/overdrive"
  url "https://github.com/chbrown/overdrive/archive/2.3.2.tar.gz"
  sha256 "d595594252ef4affb64b4366ac47b885b78316264248d2d1b375bfb82dea51b6"
  license "MIT"
  head "https://github.com/chbrown/overdrive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d01c02e8e96b4a79831f4e72dfdbc51054d5762c36a38ce54f5522885fc50f0a"
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
