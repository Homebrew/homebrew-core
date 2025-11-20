class DockerLs < Formula
  desc "Tools for browsing and manipulating docker registries"
  homepage "https://github.com/mayflower/docker-ls"
  url "https://github.com/mayflower/docker-ls.git",
      tag:      "v0.5.1",
      revision: "ae0856513066feff2ee6269efa5d665145709d2e"
  license "MIT"
  head "https://github.com/mayflower/docker-ls.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a9b2cf84ec38d48c0c0137b1a0f61231d5d91a2cddf0b355680ca6d186857333"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a5a6ebec1d000be676a4cd9e57ee15c4fb7e42a70aa7e03e32d83cfea4afdf4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06347d89230140c033d404a279c49dd2d344dec5acb83b918ea6179e1a03f0d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "061380ab4b800dd7c9963eff07bf88387b1e7816ebd40c41145fc5492ca89868"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8c823d66ba70fe7788f5cf389c71537d3c64776194dfde5b23eec60903f8083"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "146371ff787d25857ec030cb07025e9e7e062b4fba43eb59136aad8ceca57790"
    sha256 cellar: :any_skip_relocation, sonoma:         "72ee993efbc61975cadb2bd63a6c32630312083c43cfc821ea3567535f271f52"
    sha256 cellar: :any_skip_relocation, ventura:        "6a504107a216b56ac9b5b9b3f435c791c4dbb56440ca9a39bcf94d285665c580"
    sha256 cellar: :any_skip_relocation, monterey:       "cbd941bf6005f92598ee1c00165c5eb7101fac547fe0c1d2b84a55a999d940a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "69d17d15d79bfa1813ad39ae3a0250ddd919a36b4d3923412cfbc17be56316dc"
    sha256 cellar: :any_skip_relocation, catalina:       "47231e20bcc919d92de35c537c87c54f52bbcdaa85cf2bb9b27bc03a69f25587"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bec67bae5b9d59fc6386b0f7ef9e60cfa57cc06758befd8348b54fd2f83f7f64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0002977a8ff7a2a2607098a743ec898e1aec0efee43095c06b56b873fbfcda15"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./lib"

    %w[docker-ls docker-rm].each do |name|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/name), "./cli/#{name}"
    end
  end

  test do
    assert_match(/\Wlatest\W/m, pipe_output("#{bin}/docker-ls tags \
      -r https://index.docker.io -u '' -p '' \
      --progress-indicator=false library/busybox
    "))

    assert_match "401", pipe_output("#{bin}/docker-rm  \
      -r https://index.docker.io -u foo -p bar library/busybox:latest 2<&1
    ")
  end
end
