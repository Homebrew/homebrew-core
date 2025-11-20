class Energy < Formula
  desc "CLI is used to initialize the Energy development environment tools"
  homepage "https://energye.github.io"
  url "https://github.com/energye/energy/archive/refs/tags/v2.5.6.tar.gz"
  sha256 "7dcc439e32a6b1723b7809175eb43856b7817899350bbf47f794b1103dfec69e"
  license "Apache-2.0"
  head "https://github.com/energye/energy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f1c4d8d7329b810db0084e6fc69404fabc13ceda82d4b309406d15af639a9ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7694c978d9ff392a86dad2767ab0b69516522c03797e04b995268b51b1d772a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7694c978d9ff392a86dad2767ab0b69516522c03797e04b995268b51b1d772a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7694c978d9ff392a86dad2767ab0b69516522c03797e04b995268b51b1d772a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cd61a31ad9a8ad40952fc005535b2e1ae2604d80cce285a85cc1b48a1dd713f"
    sha256 cellar: :any_skip_relocation, ventura:       "2cd61a31ad9a8ad40952fc005535b2e1ae2604d80cce285a85cc1b48a1dd713f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47e341406fc77ae2d1ceae579e4680a24fff61c313b1621e0654cfbbb2bfa919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6e0b7ad8af0188f7d672afa31ad19d9fade20037fec8acc4137bf7001c0de9b"
  end

  depends_on "go" => :build

  def install
    cd "cmd/energy" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/energy cli -v")

    assert_match "https://energy.yanghy.cn", shell_output("#{bin}/energy env")
  end
end
