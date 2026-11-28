class Flash < Formula
  desc "Command-line script to flash SD card images of any kind"
  homepage "https://github.com/hypriot/flash"
  url "https://github.com/hypriot/flash/releases/download/2.7.2/flash"
  sha256 "571d9e6424b275859a9273029a2321245888ab201dbae1a3ec57a6ef708adce1"
  license "MIT"

  bottle do
    manifest_sha256 "8b0bfb351b3b2d27e6f53786f23458c42ab2b6c9e0608654c05fdb62731b7a09"
    sha256 cellar: :any_skip_relocation, all: "7ba28ca5b0372393c667b70b7841d4b9b6f587e9ce0c0c1a6bf9bb67dddec577"
  end

  deprecate! date: "2026-11-27", because: :repo_archived
  disable! date: "2027-11-27", because: :repo_archived

  def install
    bin.install "flash"
  end

  test do
    cp test_fixtures("test.dmg.gz"), "test.dmg.gz"
    system "gunzip", "test.dmg"
    output = pipe_output("#{bin}/flash --device /dev/disk42 test.dmg", "foo\n", 1)
    # On Linux, need `hdparm` installed by system package manager as it is run
    # via `sudo` which will not have Homebrew's bin in PATH.
    expected = OS.mac? ? "Please answer yes or no." : "No 'hdparm' command found"
    assert_match expected, output
  end
end
