class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.35.0.tar.gz"
  sha256 "0b5a46c1d46384ac7d7b8443aa40678c6d8c349d8a858398d5349d363b38a069"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "370f1ad9d5cb652d7adedba0cb6ea8450bcd7147b5eb301e12f92f84c281aad6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3af2ddc811483c8cf5606dd25b3bb1d3abc7d4a9d08972e88c590f10d4bae66f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27ece4d66eab0822d4d784c05bfb6e473f49fe1aa8231b19c165ae809351cce3"
    sha256 cellar: :any_skip_relocation, ventura:        "aff65073dd681242701790ca8e32a132cb70e164fe01acf212a7d8b266db7680"
    sha256 cellar: :any_skip_relocation, monterey:       "aba7cd1e52595829e782bf40ae7df6018422cb179d360d653d676f6af04c1a14"
    sha256 cellar: :any_skip_relocation, big_sur:        "af9235999294caea265e94a41310aaf8952dc2099774c3930b489bbe3145c41a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d9c01d8ef36478f3a7a2e34adda59da584b0b91be5e83981d82eabb546b4b97"
  end

  depends_on "go" => :build

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
