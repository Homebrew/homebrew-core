class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.23.2.tar.gz"
  sha256 "f4613343fa6d43866da5e34d5bd8fc72275907a4c45f64ed63fcc800b4f358c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9350a46ab1abc8ccacc5dad61660f4f2347c38f002c97d96f7c5c5699744c4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9350a46ab1abc8ccacc5dad61660f4f2347c38f002c97d96f7c5c5699744c4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9350a46ab1abc8ccacc5dad61660f4f2347c38f002c97d96f7c5c5699744c4c"
    sha256 cellar: :any_skip_relocation, ventura:        "0d1405a680b840f2b530fd933009f7a1726173b39b02fb7f0e740c8d279993d4"
    sha256 cellar: :any_skip_relocation, monterey:       "0d1405a680b840f2b530fd933009f7a1726173b39b02fb7f0e740c8d279993d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d1405a680b840f2b530fd933009f7a1726173b39b02fb7f0e740c8d279993d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a27da916c44f89069f00243b64362fc761d18df4649656cdfb81759c7551bb50"
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
