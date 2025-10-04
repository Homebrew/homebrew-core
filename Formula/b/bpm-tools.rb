class BpmTools < Formula
  desc "Detect tempo of audio files using beats-per-minute (BPM)"
  homepage "https://www.pogo.org.uk/~mark/bpm-tools/"
  url "https://www.pogo.org.uk/~mark/bpm-tools/releases/bpm-tools-0.3.tar.gz"
  sha256 "37efe81ef594e9df17763e0a6fc29617769df12dfab6358f5e910d88f4723b94"
  license "GPL-2.0-only"
  head "https://www.pogo.org.uk/~mark/bpm-tools.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?bpm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "634c02b83f4eed1869654538098c52c10571bde389661e7624c7a3a4ba14ebc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8b1d300cf51e9fa05e8eb82ca8b2bfec3203c2c8cc12f0bf9813545a668a11fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4dacfbda1751d63d7e6920d2201ff8b1eaa3a85a2317ce89f0c54595666540b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2b2f0588023837c6a2340024fce562029370273c22a79296756223907c8dc7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34949c1ed18d4065930654bb35f1fb88c4b5ab53a3571d1cbf52e6e79b452005"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19d555332dffb4fbcc6a80f15c3aa7692594b5c75fb3e01a9da6f0878fc5a98b"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f59f612366fde2bb900c8bd8481bef6c041baf0be571e622e0e4f336fbddfbc"
    sha256 cellar: :any_skip_relocation, ventura:        "483c8d0501a94e517e62dda21c44474d9315286e206e7e61e990502bcad0717e"
    sha256 cellar: :any_skip_relocation, monterey:       "4429ecadee7430b8c147e1631cea030c10953a00b3ec04e0afd031ff74a0fd8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ad965195d96e6d9f1b01732b1314af6211b101a6113aab02c9fbf799f3ded1d"
    sha256 cellar: :any_skip_relocation, catalina:       "694afec7c21549badc5c2bf55ac3f3da588370affbaa78f1087e3bb204137f61"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "46138982bb7ffca2a4f763f1fde359ac3b0cddadb65e8f2e7dbadeede5274143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e78a1d3a9c96635e57bf0ce8c329a88b8b3406a0e0ba4a19cb97e4b42727f6a0"
  end

  def install
    system "make"
    bin.install "bpm"
    bin.install "bpm-tag"
  end
end
