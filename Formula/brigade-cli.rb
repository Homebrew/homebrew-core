class BrigadeCli < Formula
  desc "Brigade command-line interface"
  homepage "https://brigade.sh"
  url "https://github.com/brigadecore/brigade.git",
      tag:      "v2.2.0",
      revision: "da052e9b8b220296b216be536364d320e8778637"
  license "Apache-2.0"
  head "https://github.com/brigadecore/brigade.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cba7e7e7ef72000d33222e554bb7be0e17ad36a16142954fbcc1b21a10a5c09e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0c8167028e40782a3cc431a32fd2ede9f11783bbc7025af8b726ea09f674f7b"
    sha256 cellar: :any_skip_relocation, monterey:       "99cefe3567397a58f3108c2a9fb5288a257bf330ce82900c50c3aa278a56fc73"
    sha256 cellar: :any_skip_relocation, big_sur:        "f88aedf8eebf204c572b94b027214da4aabdfed44570d0590eb89bc3171cca98"
    sha256 cellar: :any_skip_relocation, catalina:       "a79e472ddf433f43b93df75be2f228344f6dfa6d6bf0c42ab535a6e4973c4231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a79036c75f95a1bddc2255d4991f1a85badf24fd2e20bf3e8fdb444464f0e52"
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
