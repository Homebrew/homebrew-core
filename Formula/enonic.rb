class Enonic < Formula
  desc "Command-line interface for Enonic XP"
  homepage "https://enonic.com/"
  url "https://repo.enonic.com/public/com/enonic/cli/enonic/0.3/enonic_0.3_Mac_64-bit.tar.gz"
  version "0.3"
  sha256 "cce94ac4999bda7e69be2edadbeebd7f012aed64e9628d3b5681e5a4e0025026"

  def install
    bin.install "enonic"
  end

  test do
    assert_match "Enonic CLI version #{version}", pipe_output("#{bin}/enonic -v")
  end
end
