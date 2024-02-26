class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.53.1.tar.gz"
  sha256 "19b499135f210f4d237e65d6826433e69c7d321d21ad894abc385b2292220307"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45060af9cc746f1115229e3c883787ca1c7e749b0c02936ff862e4da838301ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "172aa7ec3e42ccc06df08e936411206b2c73dc96d3b299c2a574aa79d88da5bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d11e296bac036e011adbd51c5adeb9c7b22c9d5848cebad09c0984592887f04a"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a8012781a5846ad1e7f79daab737c63dcdba21e2b11a933f5b6f96d079ec260"
    sha256 cellar: :any_skip_relocation, ventura:        "bed9562ba297424b0d2f725a6071e182cf526617eb7750ce5360624ca431ee3b"
    sha256 cellar: :any_skip_relocation, monterey:       "b04a8c2878e268122c02544abef647be2d0c69654368193fb6340f6d1f1e9660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac379dee6e6f6c35cf7cbd1763e9319d603d9e0c3751b55a13cad71d37f05dd0"
  end

  depends_on "go" => :build

  # upstream patch PR to support go1.22 build, https://github.com/jfrog/jfrog-cli/pull/2447
  patch do
    url "https://github.com/jfrog/jfrog-cli/commit/9cba3d265b798f5a7768af2317a12de9c01ab401.patch?full_index=1"
    sha256 "2c3fb451956d5de0382371612456cfad5b907ac40e2240507a5050ea4df4c797"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion", base_name: "jf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end
