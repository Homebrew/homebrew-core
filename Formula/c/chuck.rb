class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.2.3.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.5.2.3.tgz"
  sha256 "5cf366d564a15264c8c7ca02da17b3b2740e24832f2d64bc82e1dbdde25b3f62"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f55279f082ed6688dee289226bf8ceba1f98470958e828c485c9d58cecc76d0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "734927579127d74345e9fbd39894924357bf09047e53d3ee977b53711d144fc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "497b9ee87d0f0f88882d3a392a05c634b981a14e48bf5aa6323746ba3a1865c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "89cded60c6f36d5e647915a0d1fd51383f04b3a6d153912a6474306d22935970"
    sha256 cellar: :any_skip_relocation, ventura:        "e1c0013d681ddef9ee38fba8b7bda9ee39851a1b16d539e3105db8642f8acad8"
    sha256 cellar: :any_skip_relocation, monterey:       "2e607d3e8819abcb6b72ecbe4f21614092ec989ddebb02191848c72d7c17a71c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc9c4fdd105d11e16cf6f0ff2256c1534b716013d0bb04a538eac466d817d22e"
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
