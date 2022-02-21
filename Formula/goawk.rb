class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "f610e57396cac89aaa1070ab9edfd46f09929775b58dad2ba78ed8a59e01d6a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84c221f3d73b4678882cad8e1195e61a6abc39f5585735b762c447a8f8b64d27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84c221f3d73b4678882cad8e1195e61a6abc39f5585735b762c447a8f8b64d27"
    sha256 cellar: :any_skip_relocation, monterey:       "8f9415f2cc65a7f60fe9d0ccb2800d22370b8f01c778cb7505f7684f6fad3971"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f9415f2cc65a7f60fe9d0ccb2800d22370b8f01c778cb7505f7684f6fad3971"
    sha256 cellar: :any_skip_relocation, catalina:       "8f9415f2cc65a7f60fe9d0ccb2800d22370b8f01c778cb7505f7684f6fad3971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5de8c2d579ae1a41b6b3b1b58ee189739be7b34397fda5dd81043e78f216527"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
