class BrigadeCli < Formula
  desc "Brigade command-line interface"
  homepage "https://brigade.sh"
  url "https://github.com/brigadecore/brigade.git",
      tag:      "v2.3.0",
      revision: "b5c6678c7828b85fd207e0b4219720e024da92ad"
  license "Apache-2.0"
  head "https://github.com/brigadecore/brigade.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2559e91eaa1b6209fe3f77759b86fab5346e5ddb277a45c7c42201e865e546ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c080b4b201eb38ac321bb0d9f8106a8d1f269cc18411cbb03a1a83b05e36c7c7"
    sha256 cellar: :any_skip_relocation, monterey:       "19c423a645438269645ec87bccc5921c1410892cf7c2727e4dd8025cdfef3732"
    sha256 cellar: :any_skip_relocation, big_sur:        "c58cf3a9c3fe20eee54262f3cb2a1ca227dad97e9b0395f53e81436528450a67"
    sha256 cellar: :any_skip_relocation, catalina:       "5a833713e21e69a53ee2dadde2672c040a9e4d6824f84ab7da8ad862a243ed38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aba65a916c2552a341f6e3e945bf9d3d25fd353ef5d6daa626487fd8777eac6f"
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
