class BrigadeCli < Formula
  desc "Brigade command-line interface"
  homepage "https://brigade.sh"
  url "https://github.com/brigadecore/brigade.git",
      tag:      "v2.2.0",
      revision: "da052e9b8b220296b216be536364d320e8778637"
  license "Apache-2.0"
  head "https://github.com/brigadecore/brigade.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4dd1f838e598091458ef918d05bd852942c7067a1615f1f1e702a9f15352e6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "863bf65be33e8a9e986e63b04f5b7ab9673d24f484af96e8ed1bdf3d04a92ca5"
    sha256 cellar: :any_skip_relocation, monterey:       "b587ad76c9d46dc5d2acd959849c7bc07b3b9bbac02d6d3f48d4a8735d5083e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "c20b9b671b50a9827bc60f64a8312f246d772eaf2995fc376210d43521ef6cb0"
    sha256 cellar: :any_skip_relocation, catalina:       "ae703f89adbe8a4a856209b3361eff903c523201a60ac7aa4caa343c0c3697a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b72328b4955ca9bf9c25e445d5157147550783e516069e7a590f973b41d740af"
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
