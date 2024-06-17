require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2024.6.0.tgz"
  sha256 "c6cc40900db37dd7653eb24bb095dbedbe00bb27a1024642dbf12c31a03dceeb"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb752136fdb18ceea631e6626e260b6385691af02663e0e31c97ac5a963d59b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20c64724b8206cbf15c90a05c7d16104ff894215f7941512ded8229994d84f98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1ff22ce78035dfcbc6ffb446bc18dcf1d9cc8f3863c2d6f181be32c1fbf36bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bc9e93b9a543900829ab80f0b8ef6a8c7273e228092203bfaaab88946119296"
    sha256 cellar: :any_skip_relocation, ventura:        "3133beeb8430b0f86e8fbde85b5fb0c45926b60b790ef86189b425cffd5aced7"
    sha256 cellar: :any_skip_relocation, monterey:       "f434edb274e170149b485f8608dc1659186b693bbf563dc6b2a99332ec0c5be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f627fb9dd646f59e47d1182aadd9e9f3b4214f220c247adb49c48371f6f9db81"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    generate_completions_from_executable(
      bin/"bw", "completion",
      base_name: "bw", shell_parameter_format: :arg, shells: [:zsh]
    )
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
