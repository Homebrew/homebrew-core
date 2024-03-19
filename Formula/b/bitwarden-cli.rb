require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2024.2.1.tgz"
  sha256 "cdcf04bfb3273d6a0b70e88ace52d4f1ed42cc70a464f11838b8ea7b5a8e3d7f"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ebe7b536c3d150b2a7ea2bec82e4810bccfec95674789f4c7e4d7ccca8e8d7b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dd58f0ce41c8007c0dd62cd04dc8b7bc25ec6bfb7b644adab2ae44dad5d82f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c152c5ede553be38ddc5119da4afd36f40ec83bc1d35c9150060161e2fe516a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "f13820a2054d3ae3322dcfcc1776f91d9ecd1676d225867fd9924219bb3efb61"
    sha256 cellar: :any_skip_relocation, ventura:        "57d4db95635fc9c41bf0d26e0909a9b13e5251b2426b03f394bc841709d1cbb9"
    sha256 cellar: :any_skip_relocation, monterey:       "45f2d7f684099ea4c36c9c465be4e624c46f4e85f3de4f0fd259bdf2fcb69f10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c11f7fe11fd61c149cf0ff00c65df561dbb3e6a63815a6d010261381b56e793"
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
