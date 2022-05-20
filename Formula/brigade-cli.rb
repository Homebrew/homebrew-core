class BrigadeCli < Formula
  desc "Brigade command-line interface"
  homepage "https://brigade.sh"
  url "https://github.com/brigadecore/brigade.git",
      tag:      "v2.5.0",
      revision: "838e8fd2357e3ace0b2080544a9faf3229be8b3d"
  license "Apache-2.0"
  head "https://github.com/brigadecore/brigade.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e32b00704bef443f6998dd60330c9e13c64443f358b43d8bc7812cc34c892fd3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5aa661ac2ca0c024cc154a8acdc20107d63d171b106a3a9be07f08b8260abe0a"
    sha256 cellar: :any_skip_relocation, monterey:       "0ef3da90f5c89d4c3a58925ced20e50cdd55c9eef5acd565a04fa1a1045daff6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8453e52557c129b920ee067378c8736c5b6bb543d06bd00eaf6aaacfda64a4e"
    sha256 cellar: :any_skip_relocation, catalina:       "54b0a36772b3469d1bf93e96308ec201877d54be78e44ef2c847c69f7a07c933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59385f3b5cb3d2993e5d9209b2289dd8cc841332218ca42f46ef86ae90a5396f"
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
