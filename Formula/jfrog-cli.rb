class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.30.0.tar.gz"
  sha256 "3b3274c4ebb6c729461c86253d4493afaa5ddefdbf86546d2368db979e7ff196"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37bff7e15cbda7fc69417a57f6f85e412da612474ad4698c951279bd46351887"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59a65df06d9af3afe0336053d60cac69442c8343d790550760b74261ce3405b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c98cf530abbb701cb575caf20aceccfb891e312f8f86cc185673ea862564def"
    sha256 cellar: :any_skip_relocation, ventura:        "910d92434e475b5405e99f19c11777b9567a52f2f1d5b54c917a9b17c925a6e6"
    sha256 cellar: :any_skip_relocation, monterey:       "f266dec69966d9e5806c2cdaa8abe571f6943bc7dfd41d05996778538655b4e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "0338ae8e6cd67c1d9cf3cc586dbd032a1652cb0318605cc06330e5c6c0bcdf61"
    sha256 cellar: :any_skip_relocation, catalina:       "69021683a43570cdb8423e546dc8e66ada1b4c27989b8762efdec766c36622c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97001ebf1d1716a23cb0900d6318a64f8a921701eebbac80fed98bf23ca00cae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -extldflags '-static'", output: bin/"jf")
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
