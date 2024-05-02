class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.13.5",
      revision: "d952d6df22b06147806ca1030b8ba3a4bb9e0c0c"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3927ff6844801422cb6c68988e5c762e6637c679dc9f28f6ca060a58bce8a902"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bae9c7d295f490bf932b46a5f0b40f6eb503b04b5c702df1898f5f206964acc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94e59c75c538a16df1734649ba769b095591130031149800de886effaabd2149"
    sha256 cellar: :any_skip_relocation, sonoma:         "74d270536f7f46831b3e27d2ded78e798fd583ce3a7eb694c86c4059094fc55f"
    sha256 cellar: :any_skip_relocation, ventura:        "d62ce4a1b929872735823b090291b9e93cc5456dcdbcbb4646f7af786777e700"
    sha256 cellar: :any_skip_relocation, monterey:       "bfa33d7a9c7e74f83185c776e7d8608eac12f1d4d240cca66fa1694ade394c86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98984bb980a297ddf8b8cb923c0e6ba2b1e1feddb19efcfb774d73d19af490b2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/k3sup/cmd.Version=#{version}
      -X github.com/alexellis/k3sup/cmd.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k3sup", "completion")
  end

  test do
    output = shell_output("#{bin}/k3sup install 2>&1", 1).split("\n").pop
    assert_match "unable to load the ssh key", output
  end
end
