class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.10.1.tar.gz"
  sha256 "388a63306e88dd07a8753b412ce4d59af1d9bc0403db87dce10eeffb68f18b81"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19cf91c38e1f12a1b4f12ac6f6f7d2119fa917c5669b639770bf4284ccc75f61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0db4e7a69473bd2b777fffe8b55ba7dc70ecc9b6ded71c17810fc9a3d622053"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "356cb673b5e68d34be020cb0927d7d4ef2037bc9e859eb7bb50fb3eedac625c8"
    sha256 cellar: :any_skip_relocation, ventura:        "4f1460278bf4281e84d1df3d13a1ed33d17f620537ef7d62dfeb43552468a79b"
    sha256 cellar: :any_skip_relocation, monterey:       "b7919f080ea70c28391029874b08dfd31c7f6073136f27e9eaace511aa93a1a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "663a44db2ff1b0658ab2b1633ffb5b3a51fedfb534f81c0af21cc40111070036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "250b58d53fc4473fc7874c2607916d6a2a74e3bea703db9b13f7df5295c3ce43"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
