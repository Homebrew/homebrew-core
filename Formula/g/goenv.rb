class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/3.2.2.tar.gz"
  sha256 "b5b39ce5b711a64e75a2d7df27a867645338002a2184beb49cb7984755ed6975"
  license "MIT"
  version_scheme 1
  # TODO: Uncomment when default branch is changed from 'master' to 'main'
  # head "https://github.com/go-nv/goenv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d45841c2a4104bfb19abcdb421451040da43be685b53d10147eacd1369dd195"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9d45841c2a4104bfb19abcdb421451040da43be685b53d10147eacd1369dd195"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9d45841c2a4104bfb19abcdb421451040da43be685b53d10147eacd1369dd195"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7b1cabfd4d0e2e97d8a96ed661fd2aec16c220dec58c6e7a3e931fdeee4ebe66"
    sha256 cellar: :any,                 x86_64_linux:      "1b1b6c1841ec6e61978ff36e4f47406cc6106d9449b9a32b07ae356098e712e1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
