class BrigadeCli < Formula
  desc "Brigade command-line interface"
  homepage "https://brigade.sh"
  url "https://github.com/brigadecore/brigade.git",
      tag:      "v2.6.0",
      revision: "e455508e5ec5bb9352e635c179ab44b0bc44c320"
  license "Apache-2.0"
  head "https://github.com/brigadecore/brigade.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "93938d159d0b3a5255a4bba8897a6e964ca40463210957612ab294e7deebcf27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "297bad8cabf257b37796f62ce59aad4819642e6953fbf75aeedd5841b9ea0da1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37470ccf6183c82d4fbdc502adce51bafd52c44af60547a2c54b494bdb270d66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcb3e8a2f7518bd173d3a0c0427b11b817495408fb91adbd5a7ea0b1345e2f1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e178e6bfe8c8a61e05b2ada8776a5604613048747225d3e9860dc1dad623ead"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48ec0ce5d53d16f87f4609aebdc42f589c4319ef546bec4c4cfe58d08c3cb7bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "7376dace115e55e67a571e2a249765e957b7f1f44fbe8832f01c6f64bef8981a"
    sha256 cellar: :any_skip_relocation, ventura:        "86d2d5dbfcacd337eb27194414c7e46e2fd40d7a537e17a3293ea00f6e79e7a1"
    sha256 cellar: :any_skip_relocation, monterey:       "ac352707fa64317b9a5f9761bca6e51ef9da7381e070bfcbe54aceb6561f2ba0"
    sha256 cellar: :any_skip_relocation, big_sur:        "df47dabe1fa9f31b4e192307622c25134f09672b5a3149f634b360beef60a31c"
    sha256 cellar: :any_skip_relocation, catalina:       "c8053952e004fb4455c0402425de2e7099141964f914d3c906206e69865c98cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e99412f76441b9a81e06bcb4a343498e2910d1b67a24995acbfafa840fc2289d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17449306b36ee93b21a273f1e7435610e11b903f49ebf5566dceac471fd0fe89"
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

    version_output = shell_output("#{bin}/brig version 2>&1")
    assert_match "Brigade client:", version_output

    commit = stable.specs[:revision][0..6]
    assert_match "Brigade client: version v#{version} -- commit #{commit}", version_output
  end
end
