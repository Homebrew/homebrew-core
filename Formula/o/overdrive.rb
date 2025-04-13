class Overdrive < Formula
  desc "Bash script to download mp3s from the OverDrive audiobook service"
  homepage "https://github.com/chbrown/overdrive"
  url "https://github.com/chbrown/overdrive/archive/refs/tags/2.4.0.tar.gz"
  sha256 "17d5d3d382f48de9f5b013564026ed9e37909e8dc64bc953354b3f8ae9674f48"
  license "MIT"
  head "https://github.com/chbrown/overdrive.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7c631fa29290fc91d46393bb20bd54c4c853087d20245a3fc0b3a08ccc5d6576"
  end

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "openssl@3" # for openssl (non keg-only)
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
