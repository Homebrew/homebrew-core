class Matcha < Formula
  desc "Daily digest generator for your RSS feeds"
  homepage "https://github.com/piqoni/matcha"
  url "https://github.com/piqoni/matcha/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "be0f8674638bdb1c34bd523ca6622f8d73efcfbef18d8002558af2b295caa5e3"
  license "MIT"
  head "https://github.com/piqoni/matcha.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad7f42f9b518ff57b98581bb1b533a682f23e678e0fd2bef23737b1f19415a4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad7f42f9b518ff57b98581bb1b533a682f23e678e0fd2bef23737b1f19415a4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad7f42f9b518ff57b98581bb1b533a682f23e678e0fd2bef23737b1f19415a4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab9ca1727cd9571e5871aec213f0b4cad88a162f0c48ec7818d92df78a58cc84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e199e6c8734699dd721a70e231c7e6bf420cdc6b0bee1aad7d9cd810c649483c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "415fbfbaf116b218447315b65f8f12113d47fe0d66b83d2ce0dc63831f0dd98e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Hacker News: Best", shell_output("#{bin}/matcha -t")
  end
end
