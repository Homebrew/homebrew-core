class JsonnetBundler < Formula
  desc "Package manager for Jsonnet"
  homepage "https://github.com/jsonnet-bundler/jsonnet-bundler"
  url "https://github.com/jsonnet-bundler/jsonnet-bundler.git",
      tag:      "v0.6.0",
      revision: "ddded59c7066658f3d5abc7fcfc6be2220c92cad"
  license "Apache-2.0"
  head "https://github.com/jsonnet-bundler/jsonnet-bundler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f4e614b4857b69871fc27b90b18d4e17d24951b2351f70596b39e247c9c36d67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "68bb147a2c42552de0ad48ba06125c83402858c56650e29f266443cf9974e11a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "254dc86b4ec480db94c7e1a529d71a1ccdb72924137cb9ea5a5264ec266aeed9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "254dc86b4ec480db94c7e1a529d71a1ccdb72924137cb9ea5a5264ec266aeed9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "254dc86b4ec480db94c7e1a529d71a1ccdb72924137cb9ea5a5264ec266aeed9"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4c52bef64a185727912ff7b00236894042acbc88e5ecd25796eed36b98296a4"
    sha256 cellar: :any_skip_relocation, ventura:        "c4c52bef64a185727912ff7b00236894042acbc88e5ecd25796eed36b98296a4"
    sha256 cellar: :any_skip_relocation, monterey:       "c4c52bef64a185727912ff7b00236894042acbc88e5ecd25796eed36b98296a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2399698bd1950f20494f2d50bfb636503c34d404781473749688abbc0e2e09ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bb12716302170c607b6887c0ba3601668b3855f29c4041588e8228d754fe6bd"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}", output: bin/"jb"), "./cmd/jb"
  end

  test do
    assert_match "A jsonnet package manager", shell_output("#{bin}/jb 2>&1")

    system bin/"jb", "init"
    assert_path_exists testpath/"jsonnetfile.json"

    system bin/"jb", "install", "https://github.com/grafana/grafonnet-lib"
    assert_predicate testpath/"vendor", :directory?
    assert_path_exists testpath/"jsonnetfile.lock.json"
  end
end
