require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2023.9.0.tgz"
  sha256 "7a689bf29642f38e3035cc75ba30c174e4f659d771dd3ef54b0fe62e71a7bce3"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db70094d24cfd73cc14a3e212aeedda6280e86429d3f7361af8cf553b94c1f32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63a6cf9fb48b102d606f2c952f0b3003ff5890cf56f64395a2b3701397db76e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6dff346e04969008949fc0b825c1d2e0597499ae87864b1753ae1c401a667913"
    sha256 cellar: :any_skip_relocation, ventura:        "753c7f6cc9111866c92de790bd7b801167ae28d6a014139718b3df5b1e926606"
    sha256 cellar: :any_skip_relocation, monterey:       "9f7a17e6e2989c9de806e8d5bb73dc792057ccb2a8fae27bb89aca75918bb8ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b26e7896a4475e1af0d638e2e9a60de9e937d0052f72f1854114d0d8c8827bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93aa008bef4d847a209fe51b8063ebb218c111a5eadbd672d2b19d5907f355f7"
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
