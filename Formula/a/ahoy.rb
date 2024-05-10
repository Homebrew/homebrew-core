class Ahoy < Formula
  desc "Creates self documenting CLI programs from commands in YAML files"
  homepage "https://ahoy-cli.readthedocs.io/"
  url "https://github.com/ahoy-cli/ahoy/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "38189a92e39e3ae3a34be491dd2cd010928debe46b112ad82336fafa852556b9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0ff980df2002a55329beeff9be13e0fb87c21b2c21d8ea134a15a1e2e2a5b77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af46c291ed8074770313676100c783c09f3e89f8513cf0772c49e2fa577fb684"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af46c291ed8074770313676100c783c09f3e89f8513cf0772c49e2fa577fb684"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af46c291ed8074770313676100c783c09f3e89f8513cf0772c49e2fa577fb684"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a24eb00ed3deb45025094df3034b3fb9fbf3eda0a0832e5e3073251d8c21433"
    sha256 cellar: :any_skip_relocation, ventura:        "50400846fb4102aa87185c75b2b962e1fe8c2a2ed4a5ba59dcff3c7a48427feb"
    sha256 cellar: :any_skip_relocation, monterey:       "50400846fb4102aa87185c75b2b962e1fe8c2a2ed4a5ba59dcff3c7a48427feb"
    sha256 cellar: :any_skip_relocation, big_sur:        "50400846fb4102aa87185c75b2b962e1fe8c2a2ed4a5ba59dcff3c7a48427feb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14b0c30a235c3f027727b48728ff36daaf63489df699cd99c04281270b01ae98"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}-homebrew")
  end

  def caveats
    <<~EOS
      ===== UPGRADING FROM 1.x TO 2.x =====

      If you are upgrading from ahoy 1.x, note that you'll
      need to upgrade your ahoyapi settings in your .ahoy.yml
      files to 'v2' instead of 'v1'.

      See other changes at:

      https://github.com/ahoy-cli/ahoy

    EOS
  end

  test do
    (testpath/".ahoy.yml").write <<~EOS
      ahoyapi: v2
      commands:
        hello:
          cmd: echo "Hello Homebrew!"
    EOS
    assert_equal "Hello Homebrew!\n", `#{bin}/ahoy hello`

    assert_equal "#{version}-homebrew", shell_output("#{bin}/ahoy --version").strip
  end
end
