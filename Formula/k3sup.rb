class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.11.0",
      revision: "fd9dfeaa6cd32f0d048f33705a04c14ca4aa3550"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcfa2cf627e7dcd4dbaa006875b34160cfc5ed8ab9ce1f9beea9d1f9b328a710"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44254c499b99bd16a2238c842d86cc67b35b69eb82fe74fa95bff35752ad9faa"
    sha256 cellar: :any_skip_relocation, monterey:       "4d5fb36a4898f567cd8ceaceb01db3b77b1b8fd29e2ac899c78dde5b2090ec7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b22624a0ef6adf2a4f98555575bce03fc087f9b997d0df9b386234af8a32cd0a"
    sha256 cellar: :any_skip_relocation, catalina:       "7aba6d1d734e22a29ae782cc843b587dd7acb39a8fe4e534ced37044befaa8ac"
    sha256 cellar: :any_skip_relocation, mojave:         "2095dcbf2b5ec52b588ff506148efe627bf1c1b84b48b29406897eb5b40ceaec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3ae182d09d9a363dc7c6847bbfd335471cc11ae70bc1391803b5d174ad724f0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/k3sup/cmd.Version=#{version}
      -X github.com/alexellis/k3sup/cmd.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args
  end

  test do
    output = shell_output("#{bin}/k3sup install 2>&1", 1).split("\n").pop
    assert_match "unable to load the ssh key", output
  end
end
