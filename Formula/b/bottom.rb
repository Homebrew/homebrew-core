class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/refs/tags/0.14.1.tar.gz"
  sha256 "7953d2d46f43196734723e9f7657f5adf189b281d9639b499fc7159fa08ed6b2"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99adefc044a154f2a27cd6ab40362bcbcb0e5eaa3249b522472e4033142a9ad8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a63a01bdecc85e6acfeffe4180125da1251e463ceeaf36d5e57c27bbb3d8ada6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14cb4f4d2a42e34da310ff7b340eeba4ee62b1ac54e408d7b8a4934a32d3a86a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4b14832aaf82af2073af8dbd1501121f796fc3388da41d3c286319840bdf819"
    sha256 cellar: :any,                 arm64_linux:   "6fec85797ddcf88f07a16ffaf13bc574f243bf4629f79cba7ebeb5982659ddcf"
    sha256 cellar: :any,                 x86_64_linux:  "2f36dabb764fe576b209317200b13a3897b30ad0ebd1de10114d992f26104ca2"
  end

  depends_on "rust" => :build

  def install
    # enable build-time generation of completion scripts and manpage
    ENV["BTM_GENERATE"] = "true"

    system "cargo", "install", *std_cargo_args

    # Completion scripts are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = "target/tmp/bottom"
    bash_completion.install "#{out_dir}/completion/btm.bash" => "btm"
    fish_completion.install "#{out_dir}/completion/btm.fish"
    zsh_completion.install "#{out_dir}/completion/_btm"
    pwsh_completion.install "#{out_dir}/completion/_btm.ps1"
    man1.install "#{out_dir}/manpage/btm.1"
  end

  test do
    assert_equal "bottom #{version}", shell_output("#{bin}/btm --version").chomp
    assert_match "error: unexpected argument '--invalid' found", shell_output("#{bin}/btm --invalid 2>&1", 2)
  end
end
