class Enonic < Formula
  desc "Command-line interface for Enonic XP"
  homepage "https://enonic.com/"
  url "https://repo.enonic.com/public/com/enonic/cli/enonic/0.3/enonic_0.3_Mac_64-bit.tar.gz"
  version "0.3"
  sha256 "9893534de4f97117ee5d2c2d960bcd4cbdbc28e847f76ceabbe9cf72153cfdac"

  def install
    bin.install "enonic"
  end

  test do
    assert_match "Enonic CLI version #{version}", pipe_output("#{bin}/enonic -v")
  end
end
