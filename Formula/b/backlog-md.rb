class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.44.0.tgz"
  sha256 "843cb5c50f6abbe1ce71f940e839c709e1265e3051e7387107fd9bf3b762ca6b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a89fd51749a05a0f92507d54153150740fb5228747aa7e98789c1c0f638bd512"
    sha256                               arm64_sequoia: "a89fd51749a05a0f92507d54153150740fb5228747aa7e98789c1c0f638bd512"
    sha256                               arm64_sonoma:  "a89fd51749a05a0f92507d54153150740fb5228747aa7e98789c1c0f638bd512"
    sha256 cellar: :any_skip_relocation, sonoma:        "403472dd22621d681bdeb7dd4a14291aead929b08ff91f5a67b92bfc28c69653"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bcf1297e3bd7c5e4adc2910aff11c7bcca5c52c63557a36a500b45d1430863c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "084fd9a42aacc07ad534d584f8dc4a68bd090b4be5fd7899870da36e9a578381"
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
