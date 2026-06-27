class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/refs/tags/v1.1.97.tar.gz"
  sha256 "d1253ab474de254cb77628d3274bf6fdcf087223f219dcf26186de83776bf717"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2fbd51525ce47066752a4a499b95442d17370d7ff076e4a2ffeda7c2540b186"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd735d61f4137e30937837e4a2b02a00b0e8fe8d40934c2fdaae2d783402f94a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d2f113e0be78302f03fbf79977db346db3ad52b83fb3a13922a5cee9b4a8171"
    sha256 cellar: :any_skip_relocation, sonoma:        "70368a9a5728d87dea84e7615219e8c87a79d7ea0ea6bf1f7bdeba953bb665f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e3f3ea9e816fa885ba16b0a0ee36b72f3847827499356a0b755b743bbb32737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4dab6dfedff6afb92ac22bf46ea32ee7d791bd4010c84644a4a71f24df35ca4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/mapcidr"
  end

  test do
    expected = "192.168.0.0/18\n192.168.64.0/18\n192.168.128.0/18\n192.168.192.0/18\n"
    output = shell_output("#{bin}/mapcidr -cidr 192.168.1.0/16 -sbh 16384 -silent")
    assert_equal expected, output
  end
end
