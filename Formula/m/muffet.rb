class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/refs/tags/v2.11.9.tar.gz"
  sha256 "528852785fb2a01c78b0688cfdac726b0140900f6bb1e59541a5e80fe203e779"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "main"

  bottle do
    manifest_sha256 "2e2861014d344a3f627cb4dd6c6bcb72af4205ac68bf3456f9b0aa3497cebb2e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0959d81885c46a71c7a2d59ef46570472c939f896a12fd40a7218254e60f6723"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0959d81885c46a71c7a2d59ef46570472c939f896a12fd40a7218254e60f6723"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0959d81885c46a71c7a2d59ef46570472c939f896a12fd40a7218254e60f6723"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6807b77ab33ae49ce73ad8186e7a374be2ede0b5ec007df5a0f2936e922f7e31"
    sha256 cellar: :any,                 x86_64_linux:      "99a81cb55d0384b6666b7c9eeaeae082fcbd2a0e063ccb1f1bb831e4cb77f0c3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/muffet --version")

    expected = "failed to fetch root page: lookup does.not.exist"
    assert_match expected, shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1)
  end
end
