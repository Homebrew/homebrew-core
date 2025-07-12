class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.2.0.tgz"
  sha256 "2f62c9f1b8b7bd92a65b10e0dc67fe79d4b68b2744871af8deace0ebccf69ae4"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "8b51d310e260f2e32cfd5fb16b2d70aa01382b512f98a356cc12bb0e5594b56a"
    sha256                               arm64_sonoma:  "8b51d310e260f2e32cfd5fb16b2d70aa01382b512f98a356cc12bb0e5594b56a"
    sha256                               arm64_ventura: "8b51d310e260f2e32cfd5fb16b2d70aa01382b512f98a356cc12bb0e5594b56a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5d3e2a7aadce3121f6856440fcc1b02a07d8fef14d0df26fc98a96e08516b37"
    sha256 cellar: :any_skip_relocation, ventura:       "b5d3e2a7aadce3121f6856440fcc1b02a07d8fef14d0df26fc98a96e08516b37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cb0b4903d1c279469aa989f4da7ce7f64c7b36d6e360b09a110543a29683918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fb09cdc203f00dc244749a0742e772fd9f77bb02a53e9d9b9eb68058aaee8d5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    (testpath/"test").mkpath
    cd testpath/"test" do
      system "git", "init"

      # Test backlog init command requires interactive input
      require "open3"
      Open3.popen3("#{bin}/backlog", "init", "test") do |stdin, _stdout, _stderr, wait_thr|
        stdin.puts "\n" # Send enter to proceed
        stdin.close
        wait_thr.value # Wait for process to complete
      end

      assert_path_exists testpath/"test/backlog"
    end
  end
end
