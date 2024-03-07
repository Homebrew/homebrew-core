require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.27.4.tgz"
  sha256 "bbae623611e1171c17f993fea3eb5dcc0c4c4d41cbaa8bb30d25164e31ba6f58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fec7dafc871a29b656c06035b3dc13addf8c1fdd483fe7850bfdb2c7642dcdfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fec7dafc871a29b656c06035b3dc13addf8c1fdd483fe7850bfdb2c7642dcdfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fec7dafc871a29b656c06035b3dc13addf8c1fdd483fe7850bfdb2c7642dcdfe"
    sha256 cellar: :any_skip_relocation, sonoma:         "df2de5ea0c26729751fb1da39e4075081e11655eb4aece69226f94487b27705b"
    sha256 cellar: :any_skip_relocation, ventura:        "df2de5ea0c26729751fb1da39e4075081e11655eb4aece69226f94487b27705b"
    sha256 cellar: :any_skip_relocation, monterey:       "df2de5ea0c26729751fb1da39e4075081e11655eb4aece69226f94487b27705b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fec7dafc871a29b656c06035b3dc13addf8c1fdd483fe7850bfdb2c7642dcdfe"
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
