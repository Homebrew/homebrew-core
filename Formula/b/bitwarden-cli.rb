require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2023.12.1.tgz"
  sha256 "4f792e984fad704fd70bdbcef4dcae9ec9d56c83eda38cdce979e5b4359e3e15"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eaadd998d72bf03ea4ac29b924c8e5942871d4ab1f9874fe6db8944214443677"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdb5537dffebc999b82979ad509c994d2c44af2eb89af8f376cbfa473a1025ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b379065f43f93527b8b8ac3d0f7554da97caf53fd8750a4983a865240e7febfe"
    sha256 cellar: :any_skip_relocation, sonoma:         "a146d4f54f3ce8dd108cd64d090c7e7437f366de47739c61cbdf44e3f5a1d154"
    sha256 cellar: :any_skip_relocation, ventura:        "1406d9332d97156cd8e4b1a7e11806f0696580a0143e5fcda547ba6abee7a6fc"
    sha256 cellar: :any_skip_relocation, monterey:       "9d7f06b4346b7a10162a4f7aa9d5aa884d25cd88e66b75f1ea67f3ed8719e34e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a60368b4695be24fa607b049b5690c7a87136f181566c44b2b3cf9f06a91b543"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    generate_completions_from_executable(bin/"bw", "completion", shell_parameter_format: :arg, shells: [:zsh])
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
