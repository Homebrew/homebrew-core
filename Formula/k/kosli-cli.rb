class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli.git",
      tag:      "v2.6.6",
      revision: "0cbd17e014040b3271375ae8fa6b6367b2bab644"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b038fc7bbb1938fe9b30fd3e6c339238e639b64f64dff0f231ad77f394f2769"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fd12f5a2418edf9f99eb00dbb1aea2f3939bbcc3ef11d5f22e79f6ad68391ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31b42e7f73d6c6b9b107e3467f36420db0bdd09dd6d2289c31338df352f6daf6"
    sha256 cellar: :any_skip_relocation, ventura:        "f99436473de91d99a0c7bb0bdec8d40ec0d76ca3016dee3b4888ec60f96ed063"
    sha256 cellar: :any_skip_relocation, monterey:       "8c9dabc3125c36a94f851640de441cd60bb4a9d51082dc7461375b112e85602c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8aeeec17dff7a2852003bf56ba4037ad079f1bb054a00de24e45ecf2bcd8faad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a90c44a3930866a18839a1eed17fb87072e7f76bbe8907317c18feaedef988d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{Utils.git_head}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags: ldflags), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
