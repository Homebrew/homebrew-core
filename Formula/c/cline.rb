class Cline < Formula
  desc "AI-powered coding agent for complex work"
  homepage "https://cline.bot"
  url "https://registry.npmjs.org/cline/-/cline-3.0.5.tgz"
  sha256 "1a78fb6620a2a0c86569de1f9269caafcc3974e0739205912b4233d2f7ae232f"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "43511eb558407a9c59a2c2c12c4cdb2975ad9bb704b011dee64ac64a71bcf79c"
    sha256                               arm64_sequoia: "43511eb558407a9c59a2c2c12c4cdb2975ad9bb704b011dee64ac64a71bcf79c"
    sha256                               arm64_sonoma:  "43511eb558407a9c59a2c2c12c4cdb2975ad9bb704b011dee64ac64a71bcf79c"
    sha256 cellar: :any_skip_relocation, sonoma:        "09cc546ab926dd32d70d4e0f08182709c1b6f047399aeee7226be413003c688c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc33d4c0597c3ed3bd43f0c2310aca0e139bbb980c5562a9c2a547e2696a6d86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d842c6784f15fe26881c0d6ac7cfa1dd67bc9149e39968145f90996ce7f04564"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "Unauthorized", shell_output("#{bin}/cline task --json --plan 'Hello World!'", 1)
  end
end
