class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v8.4.0.tar.gz"
  sha256 "d0c2fc7ddbe74e3fd88bf5bb02e0f69078ee6d2aeea3d8df42f508543c9db05d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36b39bc7e13e611becfb81cc6ce843abd36fc678be07bcb4823664f1af4fa3e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63a7d40d5a608f9e48eddfc96db5ded5064b3545aa69763d40d940cd8339a2c3"
    sha256 cellar: :any_skip_relocation, monterey:       "7b041441406fa3756c85a1d071f1393637de64b4f368611f195cbb86346c96a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfa44b52a5cc4ba4a7df0d2f90b3bd3ab47239c226af859b2af0b5cba2bb2900"
    sha256 cellar: :any_skip_relocation, catalina:       "cf873adca8ee04602b8daba2ae7889ff4753b8d04b6d733faec2c4e14fb0bbe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82c72a51adf671dec67e8906be0198303a5babb6a101949362ac3935e428f3a2"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    man1.install "doc/fd.1"
    bash_completion.install "fd.bash"
    fish_completion.install "fd.fish"
    zsh_completion.install "contrib/completion/_fd"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "./test_file", shell_output("#{bin}/fd test").chomp
  end
end
