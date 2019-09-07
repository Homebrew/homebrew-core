class BpmTools < Formula
  desc "Detect tempo of audio files using beats-per-minute (BPM)"
  homepage "https://www.pogo.org.uk/~mark/bpm-tools/"
  url "https://www.pogo.org.uk/~mark/bpm-tools/releases/bpm-tools-0.3.tar.gz"
  sha256 "37efe81ef594e9df17763e0a6fc29617769df12dfab6358f5e910d88f4723b94"
  head "https://www.pogo.org.uk/~mark/bpm-tools.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cbfaeff9a82a4363fc1d3b329f490c05fd89b2eb7534e295daf9cbee0bc3d930" => :mojave
    sha256 "12cab436d4ef0983a5961ebbb3daee3ad6965ef956fb5837708c8f1451b03670" => :high_sierra
    sha256 "1ae085b87f736d2b87214589e44f248697bd7136789407b487adc1b83674f72e" => :sierra
  end

  def install
    system "make"
    bin.install "bpm"
    bin.install "bpm-tag"
  end
end
