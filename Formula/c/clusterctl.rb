class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.6.3",
      revision: "965ffa1d94230b8127245df750a99f09eab9dd97"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api.git", branch: "main"

  # Upstream creates releases on GitHub for the two most recent major/minor
  # versions (e.g., 0.3.x, 0.4.x), so the "latest" release can be incorrect. We
  # don't check the Git tags for this project because a version may not be
  # considered released until the GitHub release is created.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "512a35c895c0a52e115114e630d8f052f1959650bef7d021baebc16f885569c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56a7a884d09fc80abe6d087ae80b999078e21ff22cd82218af76ebb8a2520568"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "067b097ca92c874d432ea7fe1043223c5a8327864814d5671d64ef196be0a022"
    sha256 cellar: :any_skip_relocation, sonoma:         "10c47b8c73205ef6b9619c79d2be06171e2255740e59d657eab0a651a689a686"
    sha256 cellar: :any_skip_relocation, ventura:        "62661ce17d39d1e5608515922b0f2b302753db78dcee75f4070281a617adce6c"
    sha256 cellar: :any_skip_relocation, monterey:       "a85292361bc787b1fb53386f45b89af462440156efd95cdea7b2ec109297609e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03a90cc5e5c611f64a850854b46da7ec32e692654e33738579d4bbf3e9f1ef40"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    system "make", "clusterctl"
    prefix.install "bin"

    generate_completions_from_executable(bin/"clusterctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config  #{bin}/clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "Error: invalid kubeconfig file; clusterctl requires a valid kubeconfig", output
  end
end
