class Overdrive < Formula
  desc "Bash script to download mp3s from the OverDrive audiobook service"
  homepage "https://github.com/chbrown/overdrive"
  url "https://github.com/chbrown/overdrive/archive/2.3.0.tar.gz"
  sha256 "1c963ee8d9d2cc4633b10a0677e077a9a9917c88d7184ee6936799ee41722faf"
  license "MIT"
  head "https://github.com/chbrown/overdrive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1b103c2e48d2768a883b675bc0b4dc3ccd98789c458db68b54219441250201bf"
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
