class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  homepage "https://tcnksm.github.io/ghr"
  url "https://github.com/tcnksm/ghr/archive/v0.14.0.tar.gz"
  sha256 "e48f6080f81960ec12dad0d104cb0afe876134bab862a229c9aed91f9f618c1e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ac6c8b2b97ea0139b9e56142368385a293ee5d5275a4019e4d51a068fff8895c"
    sha256 cellar: :any_skip_relocation, big_sur:       "fea6aecd86755e6a0cd3d11eb5fbba9d554e75c2bfae5619fbf528a1b713f160"
    sha256 cellar: :any_skip_relocation, catalina:      "7fd9ae651a7adbedd46e266e04260fa221c84cf1595c04e644f3e720f8f76a48"
    sha256 cellar: :any_skip_relocation, mojave:        "322df199f2e51c91d348638c3d7baed79c8e542755fe51634cc2c06ea99150a9"
    sha256 cellar: :any_skip_relocation, high_sierra:   "941dce22c70f320d75f5e961c3cfc33f837f6ee113a5a06c445e57cbdcfa34fb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GITHUB_TOKEN"] = nil
    args = "-username testbot -repository #{testpath} v#{version} #{Dir.pwd}"
    assert_includes "token not found", shell_output("#{bin}/ghr #{args}", 15)
  end
end
