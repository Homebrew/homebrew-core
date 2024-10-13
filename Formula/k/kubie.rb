class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "a1ed2272808eeb444adcb405ef385e1f03cd0d4f4dc12f4418ebde5f0b1789ac"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "45d2b5bf4e409f92e20e7e40ab2597bc3944e58b49952191639397f26a15dc8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1dc3ff251898d15423b3a55c61549c9c94a2477bf3a723d221a8604b84e3dda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdb9af05aa60fe80bb9274a5254300c6d0aaec8167ef101c2d1b76d9e0edc911"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79b81ce6914d45a0757e883117f5f8222b382f62b94636eff8e88fc2795eeb26"
    sha256 cellar: :any_skip_relocation, sonoma:         "e333225b5f2eb7f8d92a2fba93009fc7708ce27a4c12865a415caedfed80b89e"
    sha256 cellar: :any_skip_relocation, ventura:        "1714313979f78a090cd6a9bd8eaf1c0d889398536aab5ef0b614f42467ebeb49"
    sha256 cellar: :any_skip_relocation, monterey:       "ecfa627364eb8abf1816fe9751262dc73c2a9c6feb78228204a1d1d2f4939cc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5111297df8d21edf1654f6770b2855878ef6c1448b1c3792a7cb116cb7739135"
  end

  depends_on "rust" => :build
  depends_on "kubernetes-cli" => :test

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "./completion/kubie.bash"
    fish_completion.install "./completion/kubie.fish"
  end

  test do
    (testpath/".kube/kubie-test.yaml").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          server: http://0.0.0.0/
        name: kubie-test-cluster
      contexts:
      - context:
          cluster: kubie-test-cluster
          user: kubie-test-user
          namespace: kubie-test-namespace
        name: kubie-test
      current-context: baz
      kind: Config
      preferences: {}
      users:
      - user:
        name: kubie-test-user
    EOS

    assert_match "The connection to the server 0.0.0.0 was refused - did you specify the right host or port?",
      shell_output("#{bin}/kubie exec kubie-test kubie-test-namespace kubectl get pod 2>&1")
  end
end
