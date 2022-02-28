class BrigadeCli < Formula
  desc "Brigade command-line interface"
  homepage "https://brigade.sh"
  url "https://github.com/brigadecore/brigade.git",
      tag:      "v2.3.1",
      revision: "c0c965c21aa6ac6d7cfaf1f4f8c1715380bd827c"
  license "Apache-2.0"
  head "https://github.com/brigadecore/brigade.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d1422953622717b44b91c67895c603fbb441df317529b9092ef4265b495e373"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fe0721183b16c2a77f22df01ebc08b34e51ed8f9247da453803b3789b7d530b"
    sha256 cellar: :any_skip_relocation, monterey:       "1f88d6c5369c1309a27a5c767d8a875dfe44c7d5bf066569efb5adbc151779fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bc20d15b1463693dbd245c1a79d6390b3ba941d8f50660a4fba6311fcfdc5aa"
    sha256 cellar: :any_skip_relocation, catalina:       "594117c8ed56dd5c62837f97d75d09a5ad6604275edaaeebd5cd3028b348420e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d3d3e936a6acba1ca751714470016f2f0299964aa4ff8266728ea5f06ee265f"
  end

  depends_on "go" => :build

  def install
    ENV["SKIP_DOCKER"] = "true"
    ENV["VERSION"] = "v#{version}"

    system "make", "hack-build-cli"

    os = Utils.safe_popen_read("go", "env", "GOOS").strip
    arch = Utils.safe_popen_read("go", "env", "GOARCH").strip
    bin.install "bin/brig-#{os}-#{arch}" => "brig"
  end

  test do
    system bin/"brig", "init", "--id", "foo"
    assert_predicate testpath/".brigade", :directory?

    version_output = shell_output(bin/"brig version 2>&1")
    assert_match "Brigade client:", version_output

    return unless build.stable?

    commit = stable.specs[:revision][0..6]
    assert_match "Brigade client: version v#{version} -- commit #{commit}", version_output
  end
end
