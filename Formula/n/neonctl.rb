require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.23.1.tgz"
  sha256 "656497699745e2743db5eae13855cbcbcc65aa081360940b34c1f4045a0b1d6a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "595747300836f91ff5c91009fab01c52b4baaa05c92640a79a6fafd0c37c020b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "595747300836f91ff5c91009fab01c52b4baaa05c92640a79a6fafd0c37c020b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "595747300836f91ff5c91009fab01c52b4baaa05c92640a79a6fafd0c37c020b"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ec5f8db4deb12358b26f2aea5469f75e7027e82e40aab28a41529eb00f87782"
    sha256 cellar: :any_skip_relocation, ventura:        "8ec5f8db4deb12358b26f2aea5469f75e7027e82e40aab28a41529eb00f87782"
    sha256 cellar: :any_skip_relocation, monterey:       "8ec5f8db4deb12358b26f2aea5469f75e7027e82e40aab28a41529eb00f87782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "595747300836f91ff5c91009fab01c52b4baaa05c92640a79a6fafd0c37c020b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion")
    end
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end
