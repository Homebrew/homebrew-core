require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://github.com/alexa/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.30.3.tgz"
  sha256 "9fa406bac499dd9d5ebe895aa2bb3e20f28179bf218533918852a5d049d5bb39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d465c3ca996be8cf0eeb2b80c1c0300dfd77142c9c13055e5a3df0fa0f366a07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f138ecb396e9d6514361580f0235ce53d67de42279d369989743e911b3e13dfe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d46da7f667f02b1a07191b63d37d812e1085b7d671932e263bfda129923e042c"
    sha256 cellar: :any_skip_relocation, ventura:        "4f503be4336462a83bb93e276d6c11635ab9b41190f6bc449e765ac7834db46d"
    sha256 cellar: :any_skip_relocation, monterey:       "b91f70b97f8b372666688073ea8c23de39579347b0d5b8db618deba4d6b2a1b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "d12959e9aaf6c3ddfc4f22f2f585d492ed425284e5263efb977f23861d2d2765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9131c5b6e4ada2baee9a6b12e2ca6d579c820e33b0a898f1e186087d24428f71"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "File #{testpath}/.ask/cli_config not exists.", output
  end
end
