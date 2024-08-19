class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.63.2.tar.gz"
  sha256 "48716220bf80e4db71208d098140fd3ada3951fad0de607ff0f26d8518194dd6"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed98a616bfad324ca52e1e645999bc416cc6b6545b4e3dd446be2bab3835eecc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dd207d1bbc90504b74d833a555dfe695cf5e31a4c18636b11dacf0754df920d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "195945ddc40d9186457f533f2dba72fec880d12d963a233a1d51fa6771b6c47c"
    sha256 cellar: :any_skip_relocation, sonoma:         "77a9f6206b1eb67491e49f4ea8d5a0f63932cdd6ecb47c23c70b5fd1b4c78d82"
    sha256 cellar: :any_skip_relocation, ventura:        "151bf43ef9dfce903ef639868c7a0d89edb2968654ed2893562422c45fc7f86c"
    sha256 cellar: :any_skip_relocation, monterey:       "b7905bace662b844c187c5e6320aa48d32c45882473beb2e5f0298050051ad9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fd44dae0ab17b998161cf211ca91e1beecba795230f6d84d4d733a79f95ffd4"
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
