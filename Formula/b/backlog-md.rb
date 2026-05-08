class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.45.0.tgz"
  sha256 "60aad2af1fc986672d3d4db9609b86490399fb0a9a895e7969128909e9483940"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "2992ca308b16bad23029c099c629ad19c5f0980ec1de97abecfd33baf63280ab"
    sha256                               arm64_sequoia: "2992ca308b16bad23029c099c629ad19c5f0980ec1de97abecfd33baf63280ab"
    sha256                               arm64_sonoma:  "2992ca308b16bad23029c099c629ad19c5f0980ec1de97abecfd33baf63280ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "883d2ae07a82de679e619691fd35bb7b8181852776254788929ded4e599f4022"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e21a91b8592d7e6563226359d568adff3b69e26fa0c902ada68c2a168e3462b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a703895cba0f94bf25fec0c5d847cd7c6b4805af8562f6d358742ed5c8ad4fe9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
