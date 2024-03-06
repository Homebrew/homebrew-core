class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "d7a2fad5c85057faba622684269c9c2ffbf8859abb2f6bc4e73bc8c1483b2852"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cdb27b55bb38f76234b4be05e908a1f6ec41c3ca7450e8a27c492e00a8952cab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc13cffef93832b4413a1b0ac9b21ee4fa7284dc57a00fcf39aac50b389f6c7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73d884e43cc22a62ed18dfd4c204f7284ae1f12b48aaadce258d754618439cc3"
    sha256 cellar: :any_skip_relocation, sonoma:         "4eda1b74616b56bf8aa58e4c40c9c4b261d47a0b52a595ea864164d3654b2737"
    sha256 cellar: :any_skip_relocation, ventura:        "ffc3baaa2ed693694f4963e32079bdf8ba763c4363d4833461163e8ae1915cc3"
    sha256 cellar: :any_skip_relocation, monterey:       "921217805c9f2f02a2f3598bca7951b963edc43bb04e5d0bc191f6796331507c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91c83f8cbba50511f8fc3ec77c7f3b83bbaf2cc2502303cbdffbc4732bd2ab97"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end
