class PowerlineGo < Formula
  desc "Beautiful and useful low-latency prompt for your shell"
  homepage "https://github.com/justjanne/powerline-go"
  url "https://github.com/justjanne/powerline-go/archive/v1.22.1.tar.gz"
  sha256 "f47f31c864bd0389088bb739ecbf7c104b4580f8d4f9143282b7c4158dc53c96"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa467fb6384f9b89726b965b3087e16697da06b1df6e6c55eea03fa1df5b7478"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a0caa72d77ae3b738999a420d0cd11eb5446b65c76a2c06f20475bf9eaf5864"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "939711b83cba560b4caad213c1ae55e815326823b1c64d526ed57ed426a8bd9a"
    sha256 cellar: :any_skip_relocation, ventura:        "bbf420d28f94e349b3ec7fff19dc1e6b5a0c1e5a7cc9260f470d33bb8487cb2f"
    sha256 cellar: :any_skip_relocation, monterey:       "cd064aa617acdab43c0dbc8dc8d8b6244525d7636b5d3a34a1493998c35adb62"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a41907ce3c129b31732c83ce74c814d3cf57757f197cbd98a15fa8a82f952ba"
    sha256 cellar: :any_skip_relocation, catalina:       "04f4a28ca05e5cea076804fb8910d05dc1c03956f08b2d090d489d9bbd3ce9be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dad455057de8483939d867142fb9d9ae19b3e08a31ccd71739f6f8ef32c0bce"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/#{name}"
  end
end
