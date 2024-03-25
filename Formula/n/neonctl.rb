require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.27.6.tgz"
  sha256 "10b6b77b6ca2774dc6c8c2635f607f84f3f2183c52558c1e896dfaacf3ef1dd8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f887d73e2e62754a812264d3f352a48846b558578dba17ff95cbcde1fb58b3c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f887d73e2e62754a812264d3f352a48846b558578dba17ff95cbcde1fb58b3c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f887d73e2e62754a812264d3f352a48846b558578dba17ff95cbcde1fb58b3c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "11f1ffbe6e253a66565494c80252de75b422e2223bd9bf282c765554c2df8335"
    sha256 cellar: :any_skip_relocation, ventura:        "11f1ffbe6e253a66565494c80252de75b422e2223bd9bf282c765554c2df8335"
    sha256 cellar: :any_skip_relocation, monterey:       "11f1ffbe6e253a66565494c80252de75b422e2223bd9bf282c765554c2df8335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f887d73e2e62754a812264d3f352a48846b558578dba17ff95cbcde1fb58b3c6"
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
