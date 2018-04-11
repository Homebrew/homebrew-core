class Cliclick < Formula
  desc "Tool for emulating mouse and keyboard events"
  homepage "https://www.bluem.net/jump/cliclick/"
  url "https://github.com/BlueM/cliclick/archive/4.0.1.tar.gz"
  sha256 "78f9584524b2cb4710a964f4d8e23667479f1dab37240d1ffbc8dfa9841ff1c2"
  head "https://github.com/BlueM/cliclick.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "17865ef547b447df748eee8962f37d6db43243ca97701f8990311bd8d18648ac" => :high_sierra
    sha256 "5c2e0710727c5e35f48b982be3999e3df0f6005894f518aafcd67732077a9256" => :sierra
    sha256 "ffa767c10d3152c6a8a19155f93d306254146cc11661ec708207f61e5b5279fa" => :el_capitan
  end

  def install
    system "make"
    bin.install "cliclick"
  end

  test do
    system bin/"cliclick", "p:OK"
  end
end
