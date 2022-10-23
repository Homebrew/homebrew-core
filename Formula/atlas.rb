class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.8.1.tar.gz"
  sha256 "185124844f39a32f7a15c92d7b1840edbac8a48c3b04f4afbe197729dd807db7"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "935c62c45b808348fe33b0ee3b028b87b8d177fb8881d525375fbcc0a95c9e00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2f5979d8cb7eeab05b4c6da63e45cae6b3f679d671903942d51d99eb025e20a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa0eeb62c83917d540a6dcdb5863c22b1fc69a3382334527fa96eea3f7ea720c"
    sha256 cellar: :any_skip_relocation, monterey:       "c41ee5c747d24aab64e391c69a8b461f4f2c002456b36b7fd5909cfcc7a5c78f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cb432825c61c2273596d91848d7993900dff2f9157d4fb991f231ab69cc67b3"
    sha256 cellar: :any_skip_relocation, catalina:       "9156c9d18fad41a47fa9827ff41c528f15064461feeff26abf23563e74f88312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "940a5d75315e8bdc9de95c7f4702bae24d8a76e0feb7f6d5478005adafde5d78"
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
