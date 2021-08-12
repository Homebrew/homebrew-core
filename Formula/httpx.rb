class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.1.1.tar.gz"
  sha256 "487bed3400d9c45c565d96de8f02cea89877810d848d430676dd729f6f9add18"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a4a842fffbca6581a1f1698975aa2ecb75fceaec14bc9204a8d19ab0a545531e"
    sha256 cellar: :any_skip_relocation, big_sur:       "bb3f7f4dcb2bec92b4b46e76c749336143ead0c2f3ac3961a06f9d8f59dcb106"
    sha256 cellar: :any_skip_relocation, catalina:      "c3525cca8f478ffb4cf09163646541e5ea65cc13c5fe3a2341afc02bedce9123"
    sha256 cellar: :any_skip_relocation, mojave:        "0b4db6c3cfe9eb73017274c71fa2dfa221a5dc0ae1903f7727fc13b4e46734b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "436691614f5747f07918a5ceda6cd2202797029a1e619784d926e1e1297d2ccc"
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
