class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.9.1.tgz"
  sha256 "592e1872b9469852d044834f96b37bc2620437592ba9f20cc017ac7d0509b6d7"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "d69cd58578b6b3ac3d473facfbb226b42266f1b088dfc383850a7494ccc63074"
    sha256                               arm64_sonoma:  "d69cd58578b6b3ac3d473facfbb226b42266f1b088dfc383850a7494ccc63074"
    sha256                               arm64_ventura: "d69cd58578b6b3ac3d473facfbb226b42266f1b088dfc383850a7494ccc63074"
    sha256 cellar: :any_skip_relocation, sonoma:        "93e43eec76bca72d9a75bd14a100ccaec0dde746bfe060d31e6705a9aed76c3d"
    sha256 cellar: :any_skip_relocation, ventura:       "93e43eec76bca72d9a75bd14a100ccaec0dde746bfe060d31e6705a9aed76c3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e63bf250edc034e36e0910723d443b93b2ec63ea5e35a7ec77d87f7ffdb35324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7a7547dee43952159b2d65599e8dd0e1fd6f127178ab2132571633ae31f6a64"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
