class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.12.12",
      revision: "02c7a775b9914b9dcf3b90fa7935eb347b7979e7"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06ab56cfcff1bba7db7d8b27335e60e88033efb70ce5a904d945dafd40f87ca1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72afd9830c46e4478015c2f81304aa4ec5f2debf18445bc29e987dacae4266a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b5e4f886adfaf2704d78f625de2094456605e6fe694ecfde9054af8db8418ac"
    sha256 cellar: :any_skip_relocation, ventura:        "4be90c1465d777f98b6e9d2e59fd8d26eb96778f302aa9759e804af70b9bfc8f"
    sha256 cellar: :any_skip_relocation, monterey:       "8552117f0328db7fc0014ff99b304aba7fe0bcdaca805ad0a0369ca9a92e810a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ada231d79e7f2953033e8aacc4495ccbff7c37e8aebd8892a3889f49c0cb015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "918c3785d5426fd4d2b393abc73b1308adb52ac17b0c3ee3b3831bfc4d14d808"
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
