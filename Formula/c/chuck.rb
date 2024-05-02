class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.2.4.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.5.2.4.tgz"
  sha256 "b3890c1ea36c65783a5c2f4583f719afab66b35bf46b1a2fda92abc61957b9c8"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15368bc65728cc6e0adf87cccfc9f41b19ff67629bd8e708b29b63e7d00c64ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcb67f6979cad438dc4cce3ef00918455be0f8b79339f42e6bb5106f422aaff8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f32fe663b363a9c28097fd0bf348ff6588f17e662fc23a633d2522e6f8f201ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "f82999c9c282e1eff82ee5f8ff96984d20a30ddde9630ac8797a6cfbddbb4e3b"
    sha256 cellar: :any_skip_relocation, ventura:        "2bf215deefc3f7bd010d336ee315e56a38947f6fdc67f15c421538af433e5c99"
    sha256 cellar: :any_skip_relocation, monterey:       "58960009959c496943cd10236cd3bb94b54f0906c8be1c2a06301eb9ee43a569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10578c4f4479543b79659229d1bd0776930177e5a5f0345427b73c2c197252ee"
  end

  depends_on xcode: :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "alsa-lib"
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
