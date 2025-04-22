class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.5.0.tgz"
  mirror "https://chuck.stanford.edu/release/files/chuck-1.5.5.0.tgz"
  sha256 "8e35810ad4c1c9b172e7e61980f449694396fc0400bb56628faf4fc787f8ea06"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15f98a95a0bf7f5f26a8ec9e2931f75aab7fa17197dfed7841f904e6572700d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c90b4b2b59d928c661da269ecb1ec62545c1e2c71c9d1866506d8a6a60ef899"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8e37a648a05e866e47cb5bbe4b1f1a4dfcd33e8ea10ee48d76418a8da479444"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a90e85d99574ef5a786832aae043f15eb01246c5ce9bd3b4a4dd7718b394b9e"
    sha256 cellar: :any_skip_relocation, ventura:       "d601b642482546d029f603fdf96732429130c1de8b8551db68fb2c2b69a9289f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70e71224d00fe5adc9d80ef4452d3871341ecb4b9115c538548e2aab8203b4d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7598ed9db4c8a52610575233f746dce77087ae8b32714cf7f6320ff3d4ddb686"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "libsndfile"
    depends_on "pulseaudio"
  end

  def install
    os = OS.mac? ? "mac" : "linux-pulse"
    system "make", "-C", "src", os
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match "device", shell_output("#{bin}/chuck --probe 2>&1")
  end
end
