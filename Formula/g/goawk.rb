class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "2ce064f61daa11326a89f10e7ffc52b5d9b68d25d54a5577c82d27904cfe8a23"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88104945d93fcc11cc1059664a5bf67a7e158c136e89dc113f295985e41f9ed6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88104945d93fcc11cc1059664a5bf67a7e158c136e89dc113f295985e41f9ed6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88104945d93fcc11cc1059664a5bf67a7e158c136e89dc113f295985e41f9ed6"
    sha256 cellar: :any_skip_relocation, ventura:        "745498e975cb67302fd450fa91bb49795ff6d16ad6ba1a31acaa12d146b03e61"
    sha256 cellar: :any_skip_relocation, monterey:       "745498e975cb67302fd450fa91bb49795ff6d16ad6ba1a31acaa12d146b03e61"
    sha256 cellar: :any_skip_relocation, big_sur:        "745498e975cb67302fd450fa91bb49795ff6d16ad6ba1a31acaa12d146b03e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0427ab565c813ab812f6dfee8550f96059a77ff8807b93ba5860a72c85173107"
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
