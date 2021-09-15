class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.1.2.tar.gz"
  sha256 "78fcf67d143619fa428c04290acff5e84f8fde1a038c4348e490ef8834763f5b"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "103bd393103b9dbfbe998f82d284fe922141a923777e0ffb4d09ca4a2e2b4234"
    sha256 cellar: :any_skip_relocation, big_sur:       "9df6c694c5b5c0f05e6ae4483003e9ecd3ba1cbcf8e9e6ac66aedfedcf92b1dc"
    sha256 cellar: :any_skip_relocation, catalina:      "cac1f3447f2f13f6dfd36434c3999514c9e05540fc50142b939ee34c3aad3ad6"
    sha256 cellar: :any_skip_relocation, mojave:        "182fdb01e623536bf7454d8527b63b4f1eff5f38caceace05a1a41374626b918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ab4836e8f7ad808865df65a1aa9aa77919f43ca9f4ed9bc45ae6906b3feb6d2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/httpx"
  end

  test do
    output = JSON.parse(pipe_output("#{bin}/httpx -silent -status-code -title -json", "example.org"))
    assert_equal 200, output["status-code"]
    assert_equal "Example Domain", output["title"]
  end
end
