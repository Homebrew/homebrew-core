class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.0.4.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.5.0.4.tgz"
  sha256 "b0275277692f1286f8ce634ce7329e1417b03bc5df80ea1ec71d54131b7e8ce3"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83e6a042c751f4c07d39f9d1c3cfa78ea488045f8420c3163dd2b7a556208d1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed9f1146f283e27e4c0758dd716768710487b1e631e6999c357e4980a8be0f60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b8262e2ab09f456736d94fbb1c24a28a9990d174347363843eb14cb962ecdf2"
    sha256 cellar: :any_skip_relocation, ventura:        "798d66c9bb14c5855521fd2b2a25e806335877887083be969746641ab60d6049"
    sha256 cellar: :any_skip_relocation, monterey:       "e0916c29dc7aebcbcebe97c017244c7ec57c0c8e7d9888d417cb18c6eac99fd3"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e72d4d9a70150b3821048b24a4eaeb496c98afc752228ecdd51059726b2dd46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79180251fd71c4a2ef7fc3c2401fee712cc09e9a44fd4e16ad441ae01159007b"
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
