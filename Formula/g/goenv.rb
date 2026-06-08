class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/3.1.3.tar.gz"
  sha256 "e5d0b0fa87076666b2504d643247fbe6e5f874baa776ea8589bd23b481fdeda7"
  license "MIT"
  version_scheme 1
  # TODO: Uncomment when default branch is changed from 'master' to 'main'
  # head "https://github.com/go-nv/goenv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e16fabc140d5f677767f1023d49aa713409c063fd737474d8c9727ebadff7412"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e16fabc140d5f677767f1023d49aa713409c063fd737474d8c9727ebadff7412"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e16fabc140d5f677767f1023d49aa713409c063fd737474d8c9727ebadff7412"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea562407a2601fa6c2176f4ba3772d6a103df67ad1ee842ccc3bc69439258485"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e489f823fca591f8faaa2b0220bf365627cdd114f76cb568afbd8a13cd5ce31f"
    sha256 cellar: :any,                 x86_64_linux:  "7b93a55d03d323d131d706500f1ee2e85bf336f53c2def5562e0f101f2ee1033"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap&.user || "homebrew"}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"goenv")
  end

  def caveats
    <<~EOS
      If you are upgrading from goenv v2, you may need to remove the stale shim:
        rm -f "${GOENV_ROOT:-$HOME/.goenv}/shims/goenv"
    EOS
  end

  test do
    ENV["GOENV_ROOT"] = testpath/".goenv"

    output = shell_output("#{bin}/goenv root")
    assert_equal testpath/".goenv", Pathname(output.chomp)
  end
end
