class Asnmap < Formula
  desc "Quickly map organization network ranges using ASN information"
  homepage "https://github.com/projectdiscovery/asnmap"
  url "https://github.com/projectdiscovery/asnmap/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "3372a0d4b4cef1e1754171a0a631c2068c61e6e4aecaf1f3b61ceb1e93a18802"
  license "MIT"
  head "https://github.com/projectdiscovery/asnmap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21bd51fa6d9f2533ed8622ec1563ee9b8d9998c1fe6148fc937383b85c1f365a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c73123e558f2efca071719399b266ded3a9e32ec70ac878c3484bb49c8cfc816"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92ccdacc599ebad70d948d7a717df8f84236ef4fa05c3d0bdb441189e043926e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8ea6f7d0aebb88c87c1e3f6f7f553240eb58091f4abe2a084bf7e9d5fcf2d38"
    sha256 cellar: :any_skip_relocation, ventura:        "767081ee905e47916985b70ee93223e9812c2a244481cdc9cc64474a9ba05495"
    sha256 cellar: :any_skip_relocation, monterey:       "7bbe35b63f110d492008fa0d75b66692b9d403223e83c73d94d3ddb2f26a0c55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86109e0e34fdf46da3043e0069f625b50c7059448c2bf4c7bfdb1c1642c28ab7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/asnmap"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asnmap -version 2>&1")

    # Skip linux CI test as test not working there
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # need API key for IP lookup test, thus just run empty binary test
    assert_match "no input defined", shell_output("#{bin}/asnmap 2>&1", 1)
  end
end
