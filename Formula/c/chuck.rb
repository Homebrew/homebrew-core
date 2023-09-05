class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.1.2.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.5.1.2.tgz"
  sha256 "f72473835cb9a6acb25cb8ac92e748de1c11829ff2358c0bada45ba4796e0e1c"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ccfa6e9a7e0902bb7ad4267a8a5bc660e1edc00a817bb93b9490e98d454fe3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "957db0e5cc3cb7180d7a9ac26cf8b0222ed15be649bc706369505ae1da15bb04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0738b7058ce8b34ac9f9dac2e9410c09e9931252fc538967e357c7ec3a2b6995"
    sha256 cellar: :any_skip_relocation, ventura:        "ecb5ebf565bbfaa5aa4fb7e8c96925554bb36f3bb871b1c09870b9aee58f5e09"
    sha256 cellar: :any_skip_relocation, monterey:       "b9ae3d4c02169652f07035fd5f33080a48fac09a443a8b56148edc8948e40c3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "36651570a41da761225aa4bb60c8bc7a2df6745dc68eff4c3a6cc0d0a6470c19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e4f7b271da8bab0f992fb09438aec4c115dfb222b1363b408f5a31f7d961f56"
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
