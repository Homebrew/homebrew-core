class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.4.1.0.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.4.1.0.tgz"
  sha256 "74bf99ad515e3113c55b833152936fad02a3cf006a54105ff11777c473194928"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf98fb85e4a840f114a7205f218f2b24447e245430b8ce8aa9e9186f915c9a39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15d78dc288ef27e39e5440230eee351b8bdd5b9a3600d4a3091b5449301ecaa4"
    sha256 cellar: :any_skip_relocation, monterey:       "bb0e35876b998b1fe1e2031cf46e5ad33d452f1e5b7c1df36d2b2fab5be58db0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0c77148d868e250d5de2e454fa57b63d652c139017bbecdab93bb3083e15a27"
    sha256 cellar: :any_skip_relocation, catalina:       "c5d475570562295a5ffd68ea6f43444ec6ca35c21d39d851e2dfda605d0f4d8e"
    sha256 cellar: :any_skip_relocation, mojave:         "479931bcc4ed8b29d80ec7f259f01f113ac5f6a6a75be3228bca9c018b0ffe3d"
  end

  depends_on xcode: :build

  def install
    system "make", "-C", "src", "osx"
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match "device", shell_output("#{bin}/chuck --probe 2>&1")
  end
end
