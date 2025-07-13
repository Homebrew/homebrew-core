class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.2.7.tgz"
  sha256 "6fdee51b12c318e6f12af9c35247a1e626b1d57405b47960d9380abe96590b86"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "2a68913e1ca0b2c871493704e59711984e3e2b8396b4072671ed8f5396961e31"
    sha256                               arm64_sonoma:  "2a68913e1ca0b2c871493704e59711984e3e2b8396b4072671ed8f5396961e31"
    sha256                               arm64_ventura: "2a68913e1ca0b2c871493704e59711984e3e2b8396b4072671ed8f5396961e31"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8e229b17fc1c9872553cd257c826e2428e87e4769aabf880263a81234de71d9"
    sha256 cellar: :any_skip_relocation, ventura:       "e8e229b17fc1c9872553cd257c826e2428e87e4769aabf880263a81234de71d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f00f48170a0c0ce0cd32304757617530e5672fc65a85b82111d2be6cbc04328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44dceddfaabbd0055acf3cbd5029c9e099252116c557b269e898c614435a746e"
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
