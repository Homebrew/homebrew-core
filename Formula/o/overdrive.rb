class Overdrive < Formula
  desc "Bash script to download mp3s from the OverDrive audiobook service"
  homepage "https://github.com/chbrown/overdrive"
  url "https://github.com/chbrown/overdrive/archive/refs/tags/2.4.1.tar.gz"
  sha256 "accc3ec4dab889f6bc003970be102ca7c85290b6516f71c8394e61946fb28860"
  license "MIT"
  head "https://github.com/chbrown/overdrive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2ea3e686b4157fced49eab3f6bbf5b467140e7d07f130a810902a5bf940aca0e"
  end

  uses_from_macos "libxml2" # for xmllint

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
