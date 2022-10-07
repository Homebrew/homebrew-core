class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.12.8",
      revision: "018b1a0b08c2c08f0243b9bb7b0139868d1059eb"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d374868b80a11acf2fe48243edd67801827ccf240c9c743daf6a34a138908651"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "728b4adad2511b3e0eabfac6944f66464a18bbdccb0a9da0300471bf59711c42"
    sha256 cellar: :any_skip_relocation, monterey:       "1e092a07f0e19289393b52e3a4ef802558a0677837a6a66d6fabb6e5e0d3d333"
    sha256 cellar: :any_skip_relocation, big_sur:        "603d9a57e86f3e94d5dc4cd93403fc87228a602b44f1b4baafa2d4f9ab2912de"
    sha256 cellar: :any_skip_relocation, catalina:       "94dda040ca853c5240ba4f41f13ce85068e5ad12ffd4920fa96368146b35633d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98d7e5c2803946c4177569dca126a9e51d885d85a3aea60545d2cb9d20d2f6c8"
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
