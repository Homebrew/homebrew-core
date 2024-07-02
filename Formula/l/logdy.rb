class Logdy < Formula
  desc "Web based real-time log viewer"
  homepage "https://logdy.dev"
  url "https://github.com/logdyhq/logdy-core/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "819992c40c1857ac7eef512fd13d7e7fce1c5576a4997a8d1a1aea6d04bd54c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68250b4d6214de35db46bdc12815731b6fd260eab57b48ee0474bd1729706f3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c1051cee12bd2439652459be4b157c28b23e80c9892bf4f47a4fb8973745efb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9337edfbaa9ddc6e948c5e1ddb8c5f5d594eb3d82c18e729708a35e5a17bd2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8bba752875cc0945c6397f7fbda4d2dcd86fe772081818c36edd7b5e9a52cda6"
    sha256 cellar: :any_skip_relocation, ventura:        "05f28e0bfc8d20acd69fa11b36519950da9502a9833bd890d5d297306b654825"
    sha256 cellar: :any_skip_relocation, monterey:       "55a0c71d332ac5b1193ec22428fe1e3a84ca8fba0716076483888401b47b254c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "516a035136a7e696e5953e1c197aa4efe2363e0b8e2c1415fd4bd7388398b688"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'main.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    r, _, pid = PTY.spawn("#{bin}/logdy --port=#{free_port}")
    assert_match "Listen to stdin (from pipe)", r.readline
  ensure
    Process.kill("TERM", pid)
  end
end
