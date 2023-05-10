class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.37.1.tar.gz"
  sha256 "daff1c7722cb213737448f2ebe00065d3f3e876143f1d0b9e80447a9f4da9ae9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f78cfd32060402da6ae956f01220cf80fc433935bd80df030707263407fe18a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f78cfd32060402da6ae956f01220cf80fc433935bd80df030707263407fe18a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f78cfd32060402da6ae956f01220cf80fc433935bd80df030707263407fe18a"
    sha256 cellar: :any_skip_relocation, ventura:        "2db3397621dc8f22cdad8b24c772745b7febe30567e622259497b406a05dbd00"
    sha256 cellar: :any_skip_relocation, monterey:       "2db3397621dc8f22cdad8b24c772745b7febe30567e622259497b406a05dbd00"
    sha256 cellar: :any_skip_relocation, big_sur:        "2db3397621dc8f22cdad8b24c772745b7febe30567e622259497b406a05dbd00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "125473a3f64c2d19e88bc8d4283ac693dd180818c49ce37af7bce7f38b144ae2"
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
