class PowerlineGo < Formula
  desc "Beautiful and useful low-latency prompt for your shell"
  homepage "https://github.com/justjanne/powerline-go"
  url "https://github.com/justjanne/powerline-go/archive/refs/tags/v1.26.tar.gz"
  sha256 "65aa911d50f3695b37da92a53ed417b6cf263a9e4091552b77921a6057dbb320"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0480d19fab072ca6629e01d8227f0b024a311d388bbd3fb0a19fce84edc3bc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a88579eb3e6e19d6f79aa2e400ee1802a99d768dfcc741d101330bd6c7db64c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84ae5288f6f951b18a66225201262b0cef2b3aef40fc2c98ba18e271956122d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "808ce2687f6a301d3ff0af2a38d6d8c4f91e215d93f4a6f5b5a22738b072a586"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b70ce76f766143c625d1921a63df6faab3f189d04b2a4f33644a60b34d041a1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9c395823e650375d21a134373d80495051210a5dadf50185356d1aaebd9dcd6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"powerline-go"
  end
end
