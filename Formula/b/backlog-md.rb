class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.36.0.tgz"
  sha256 "e00b87e023c32b9638a947592ac2fefd3e70f290694e707f6261dbb44bde47a9"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "3cd1d308cacf561923319b1dbba874f9e013d427f875442c55616fc70aa45e24"
    sha256                               arm64_sequoia: "3cd1d308cacf561923319b1dbba874f9e013d427f875442c55616fc70aa45e24"
    sha256                               arm64_sonoma:  "3cd1d308cacf561923319b1dbba874f9e013d427f875442c55616fc70aa45e24"
    sha256 cellar: :any_skip_relocation, sonoma:        "effa752853339a88592c634244694ca82e0a3a2dcad8e648d507527468a704e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bdbe553161616afaa075b9e30909a67a1071218fd29765695c0ebef61e1f575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e89d72c636fb4abb05929d992d44461bf68607c4202b12d37c57e3c574bfcbd"
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
