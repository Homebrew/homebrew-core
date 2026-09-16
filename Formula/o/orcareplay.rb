class Orcareplay < Formula
  desc "Record, replay and fork debugger for AI agents"
  homepage "https://github.com/Continuum-AI-Corp/OrcaReplay"
  url "https://registry.npmjs.org/orcareplay/-/orcareplay-0.3.0.tgz"
  sha256 "dcd6df98f5334a3aa471bf5b6b3cec8653c76750f526c55c6b36f0f91ccae0f0"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/orca --version")

    # `list` in an empty directory is the cheapest command that exercises the
    # trace store without needing a model provider or a network call.
    assert_match "no runs recorded yet", shell_output("#{bin}/orca list 2>&1")
  end
end
