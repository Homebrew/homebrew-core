class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.12.1.tar.gz"
  sha256 "e7cf9aa7b31ad2958e912402ffe4b3d8b4dc8234244509f0d347947ff2ff7abd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0795986469f8456dd4bcaf38f099f8613b5e03be4330a693bb51fcdcfc027bd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "062231053667f4e857912fe98e59f6a85d0997df92cf2f5fcc7b1c4fc75a40f5"
    sha256 cellar: :any_skip_relocation, monterey:       "783be8ac7e3da45e78d44a836678a87d43846dc9c8624e84ae40e475d410ed62"
    sha256 cellar: :any_skip_relocation, big_sur:        "e013ed68a6f92f0a2a0ad47a183fe3f8fb22220995499c6f1b4b90730290e33a"
    sha256 cellar: :any_skip_relocation, catalina:       "80307d53b9b31d1aad4c25963a80cc84d2d9b6480203df586f229800e9068a88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d74e233127637ee039d1583a4008d1b5995f255d2cc229fb848dd922aada944"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -extldflags '-static'", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    system "go", "generate", "./completion/shells/..."
    bash_completion.install "completion/shells/bash/jfrog"
    zsh_completion.install "completion/shells/zsh/jfrog" => "_jf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "\"version\": \"#{version}\"", shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1")
    end
  end
end
