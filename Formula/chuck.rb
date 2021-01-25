class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.4.0.1.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.4.0.1.tgz"
  sha256 "11a20c34b385e132bf43d5ae6a562c652f631828cc6b1562a4c029bc9a850ed4"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "0d7d491edff5d042134f2930bc4d66ed6c2a00f727ef3b9db26970b8f68a9c41" => :big_sur
    sha256 "f22a34388deb237f78a2197aede95396de6b15f629c92969b75f326f004ee815" => :arm64_big_sur
    sha256 "dda91ec418bd79160d2e9167e5096f9a81075558fcf8943e509c355c5e827e98" => :catalina
    sha256 "524a64579b8132a18d7a0ad9edd200a623ac954a72663b4ac229958e7a64541e" => :mojave
  end

  depends_on xcode: :build

  # Big Sur compile fix https://github.com/ccrma/chuck/pull/158
  patch do
    url "https://github.com/ccrma/chuck/commit/51f8dfa2a6d0cf2fc8f39760cae8a754ccdaaee5.patch?full_index=1"
    sha256 "f3853d6d107fe7ccd235ef5e02eb396f58ce55bb9e7ac7bd4043146af9d08536"
  end

  def install
    system "make", "-C", "src", "osx"
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match "device", shell_output("#{bin}/chuck --probe 2>&1")
  end
end
