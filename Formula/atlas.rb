class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.7.1.tar.gz"
  sha256 "1fcefa4df30452a61feee9dca45000fc51388bf9506081b1ec723091dca84190"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d42e99b3e287351e9fa1f280551ce15e997aceb2b60f7d0a28a5c615fb5ff2b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff9fb42a7740678db39721940bcd7ddde48e92ebb1d28facdfc1308cde6632f4"
    sha256 cellar: :any_skip_relocation, monterey:       "03ac31eaae5cf1f9f62adaaedca119b179d519f59cac4fa49dfd8ca927b9d543"
    sha256 cellar: :any_skip_relocation, big_sur:        "4aa84878a70e8798ce09177af63e472cd3468144a1e82c7b2ee4868ec38b873e"
    sha256 cellar: :any_skip_relocation, catalina:       "064d6c10215fb2acb70568571fa1e740c61da2526eaa02340f4d1c7f637bc504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94186f7762d966bd6d7d64dabe278d311420ee8db2d24ff4ea695b9541a4af1f"
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
