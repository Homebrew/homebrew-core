class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://projectdiscovery.io/open-source"
  url "https://github.com/projectdiscovery/httpx/archive/v1.0.2.tar.gz"
  sha256 "ba3108b91aa9ce23fad4bac921676105f16f8d65c9f276f0e657a3d45451cda2"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5bc253dcee7026509d3a90ca5055907d08483d7dbe5c60b6a5000daf8c70d4b1" => :catalina
    sha256 "145169991f1cbe15fae1b7070ea067074df5a2f81c2774f114854a74e90c4f4d" => :mojave
    sha256 "39efa049e8a2e7c657f0762e2792f24586f3bb309397645b892e14d34be07714" => :high_sierra
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
