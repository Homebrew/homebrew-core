class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  homepage "https://tcnksm.github.io/ghr"
  url "https://github.com/tcnksm/ghr/archive/v0.13.0.tar.gz"
  sha256 "53933c6436187f573128903701ce74ac341793e892d3c2f57c822c0ce3c49e11"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fea6aecd86755e6a0cd3d11eb5fbba9d554e75c2bfae5619fbf528a1b713f160" => :big_sur
    sha256 "ac6c8b2b97ea0139b9e56142368385a293ee5d5275a4019e4d51a068fff8895c" => :arm64_big_sur
    sha256 "7fd9ae651a7adbedd46e266e04260fa221c84cf1595c04e644f3e720f8f76a48" => :catalina
    sha256 "322df199f2e51c91d348638c3d7baed79c8e542755fe51634cc2c06ea99150a9" => :mojave
    sha256 "941dce22c70f320d75f5e961c3cfc33f837f6ee113a5a06c445e57cbdcfa34fb" => :high_sierra
  end

  depends_on "go" => :build

  def install
    # Avoid running `go get`
    inreplace "Makefile", "go get ${u} -d", ""

    system "make", "build"
    bin.install "bin/ghr" => "ghr"
    prefix.install_metafiles
  end

  test do
    ENV["GITHUB_TOKEN"] = nil
    args = "-username testbot -repository #{testpath} v#{version} #{Dir.pwd}"
    assert_include "token not found", shell_output("#{bin}/ghr #{args}", 15)
  end
end
