require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2023.10.0.tgz"
  sha256 "def0cfbff9ef4ed86d45b403b7522287de02494d8358677166876a80e81d9453"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d02842def5976ed62999f57ca52a1d565f5a806d2a51fa942ce48b5523b42e93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "864f97bb84184c94f91628792468aa78e777781ff7c0cf7d106c3c392211ee2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a76a847a0219c379774fd44652737c983be5d900243d3056027f33cb42422fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "c83e5807ca68ecd4305535673074a27a5c260018c0ac30f660868dc3cbab767e"
    sha256 cellar: :any_skip_relocation, ventura:        "c7a632839afd68c63701478a3d4340f92a46d22ad76707a179d156f8c05a9532"
    sha256 cellar: :any_skip_relocation, monterey:       "70a557cfe6c133c09fc2d7de0532c4f9b16597ca28f4bb238c5295738cb2df70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80802470068d84f167ea087c81e564c3fdac958fb22d4dcc946880a856c55a15"
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
