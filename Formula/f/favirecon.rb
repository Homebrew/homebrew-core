class Favirecon < Formula
  desc "Uses favicon.ico to improve the target recon phase"
  homepage "https://github.com/edoardottt/favirecon"
  url "https://github.com/edoardottt/favirecon/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "7f1cccacb12250d4e667b82a1738d339d575fe7870c976ffbc18ffcb88d3690c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2a5391be5911c775bf17e4bdeb44bf62daa8b4810e83754b4843062a73c2e51"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53801c5f9005d8fd72a140d1a77d4a31f899de8b851bac6657dcff25b11f11d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5c50759f35661b9722fd61482a76b8e4f7e9a87cd2e8f06a707131f7fef978d"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c33c90e50eda4899354d0335402e46ae14b6f17ccdd078baf3fd375734092a3"
    sha256 cellar: :any_skip_relocation, ventura:        "a863384d568854e26f6bf17fa04fa3dfe5cb042a08d2f62d136092efcf1baa6f"
    sha256 cellar: :any_skip_relocation, monterey:       "1f1be1153053cdf3de43c659282dc44bc707aecadbe305a2b5a30d58a0e7bcf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7038417a9c8c270116f590011f9375af8a62b0d1474badfbc7d3f1ac04abd9c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/favirecon"
  end

  test do
    output = shell_output("#{bin}/favirecon -u https://www.github.com")
    assert_match "[GitHub] https://www.github.com/favicon.ico", output
  end
end
