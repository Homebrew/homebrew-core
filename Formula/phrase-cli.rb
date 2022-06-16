class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/cli"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.4.11.tar.gz"
  sha256 "5d5eeff5df6b44633f6119d0896bae0d79318d79d9bbe6bc80573d112385866e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "262bc8795ea676d3b82a0df610c57efb7d531c764fd77774f59cc4764d8ee52d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9afdeb185db095e57909c48f714b2c82bb999b4ab16d98037f783fd15e8ac5c"
    sha256 cellar: :any_skip_relocation, monterey:       "03c36f31b96eda1e44b3428e291a9d83e26087e24bfb3ff7f668aaa5bd764bd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e473f2e5573c7332e0000f5dcfb61b645a2e43ba16ce7b53c70a7d8b4bbf0ce9"
    sha256 cellar: :any_skip_relocation, catalina:       "a623579167f4e18569d0ae31bafd310ea800f3621521b8e8b81ce179ae89001c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d2c1f948113922a89236e09a78eca06833c16aa6f2f685a99190fee3772238d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X=github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    bin.install_symlink "phrase-cli" => "phrase"
  end

  test do
    assert_match "Error: no targets for download specified", shell_output("#{bin}/phrase pull", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
