class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.9.0.tgz"
  sha256 "bf54dcf2563769587ac0194b4b6034ba97a17ec3ba56928ca7995e667a8f5e61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "491ea5e29bdaa5cd12b82f2412c11a5a8eb34baac66b8d145219b5403d595b0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "491ea5e29bdaa5cd12b82f2412c11a5a8eb34baac66b8d145219b5403d595b0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "491ea5e29bdaa5cd12b82f2412c11a5a8eb34baac66b8d145219b5403d595b0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "59bfefb34b9f8003d242e2d1cc8dcb2886afb7e0401c09bd64c69010418fe6ea"
    sha256 cellar: :any_skip_relocation, ventura:       "59bfefb34b9f8003d242e2d1cc8dcb2886afb7e0401c09bd64c69010418fe6ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8521b047d9fa3f8f6979f2a3a49832efb00c3aee7984166a906b948e40c7be7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "491ea5e29bdaa5cd12b82f2412c11a5a8eb34baac66b8d145219b5403d595b0b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion", shells: [:bash, :zsh])
    end
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end
