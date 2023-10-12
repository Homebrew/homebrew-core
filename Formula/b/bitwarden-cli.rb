require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2023.9.1.tgz"
  sha256 "403e8cbce0d27cf990d6fb3633f93be771704a3b7c200ec8fd2269747390f350"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "428a2aa5164c4e358dae04d26a75f593f5d6684ef06a8f363bb463582c14bf7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25b226fe8fe0962bdaf9a9749d72245f82ba41bfacf5b7b1cf55fb59fb4d26db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "844af4dbd66a8dc37cb6773d02e7b99c9ecc2489bd8f15cd249252e16c0e4be8"
    sha256 cellar: :any_skip_relocation, sonoma:         "aafbf6414f97eb8cd6da511434dd5a34c337c63c8b8d1631ff53b9e71d5962cc"
    sha256 cellar: :any_skip_relocation, ventura:        "2f2111670b78afa7cb3a7e7ee930731920483dea2dd36198f63ee3d293acc36d"
    sha256 cellar: :any_skip_relocation, monterey:       "a950c0048340b97587839973764a1ca21cd4a73ae6e35040a664160feb8452fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dec5a995ff52aa91ff7d78c74b33b76bf76fc9246aa5c97c5912469813339b20"
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
