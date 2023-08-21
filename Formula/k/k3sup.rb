class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.12.15",
      revision: "eecca82a26ffd8195d3064994525fa9a771ef7ea"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69810ccd9d67908b65bfa40a7fe2f84b455484735ca318f608d06e6d0643ab30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e8582131dc438d3c9e4959476acdf9bc5a4d8f3a5151186ee2bf15f1d8e3bd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3296d11c5627a2f6d8cbfa73b71de714e85bb11ce6d081922c10e99bf420db8c"
    sha256 cellar: :any_skip_relocation, ventura:        "7ecb09f62dc5cfbacd57d183c13d83d14cf59d63de8a632a490ff61f9d067fce"
    sha256 cellar: :any_skip_relocation, monterey:       "e82b8858020093ec0aa398773776d6b026e9f23efe8183b6c9b4608d8ec702d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "40b39ae9d6f57ca36c0cb8d086d948d4ab44a57e493c83ff089b134465fe2bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d1cc5066c149ea919ca7c3516a77b11aeddc649f0fec45e56321a287573034d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/k3sup/cmd.Version=#{version}
      -X github.com/alexellis/k3sup/cmd.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k3sup", "completion")
  end

  test do
    output = shell_output("#{bin}/k3sup install 2>&1", 1).split("\n").pop
    assert_match "unable to load the ssh key", output
  end
end
