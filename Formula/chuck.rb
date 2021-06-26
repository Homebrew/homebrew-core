class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.4.1.0.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.4.1.0.tgz"
  sha256 "74bf99ad515e3113c55b833152936fad02a3cf006a54105ff11777c473194928"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f22a34388deb237f78a2197aede95396de6b15f629c92969b75f326f004ee815"
    sha256 cellar: :any_skip_relocation, big_sur:       "0d7d491edff5d042134f2930bc4d66ed6c2a00f727ef3b9db26970b8f68a9c41"
    sha256 cellar: :any_skip_relocation, catalina:      "dda91ec418bd79160d2e9167e5096f9a81075558fcf8943e509c355c5e827e98"
    sha256 cellar: :any_skip_relocation, mojave:        "524a64579b8132a18d7a0ad9edd200a623ac954a72663b4ac229958e7a64541e"
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
