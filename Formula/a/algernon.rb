class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://github.com/xyproto/algernon"
  url "https://github.com/xyproto/algernon/archive/refs/tags/v1.17.2.tar.gz"
  sha256 "2c9998c78170e431990ab0ce395567f1d7de051161044811b9e9d3468fa033df"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d4960f8b8ab5ea79304230b68ebb91bb2a11d78e618e35413ce9f30de8a6974"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c772456f9441b400656bb527c81e715a0cb3f8063b95844856c33e8aadae8c81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c7d078c7cd0ed7eea3ffe2ace1a62e678b5452a6c0d53ead7af1d0d354d29d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "54c2c525550b6b07d2693867100a3c4e20008e3535d77248609f7442aa947f70"
    sha256 cellar: :any_skip_relocation, ventura:       "1b1802108b7b03611cb91edf8fc85b0e78dfa2354bae76290fc3c8baae839af6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e99310d3d041c74da5e61dc6bc64d90ffb104c1b8b5d21ac1b978891e45cde1f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"

    bin.install "desktop/mdview"
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":#{port}"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:#{port}")
    assert_match(/200 OK.*Server: Algernon/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
