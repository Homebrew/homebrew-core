class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/0.6.4.tar.gz"
  sha256 "ee949805515a1b491f9434927ac3d297b9d5d9d261e3c39e036b725d807b10de"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a58298102a3462857527816f20a2176961ec1c970e57aa820f2cb9a6169397af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "858638f2ce93c5cd1f0f4b3fe5a34ad2978c1af1d1ff72fd6dd8aca954593505"
    sha256 cellar: :any_skip_relocation, monterey:       "841153e02d47148e90e0eff96714710b63fcc0fb5fac8d4b1789e5a040d9763e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f047f6173fd9bbee11fb9ab8c3e74a57426115b41ef561cebff58890ec781b7b"
    sha256 cellar: :any_skip_relocation, catalina:       "54c224a8df54fce11acbb473e5aa51e2a4b39b635e119c7dc49da0c7dbbba50a"
    sha256 cellar: :any_skip_relocation, mojave:         "b4f68a0f65db30f870df86e1e2acd4eb32196f1da452c013d1e49f65aa3484a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45a3ad6c888122f5e082f8ab30854c0903316d7898917c16eda01804456db0de"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Completion scripts are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/bottom-*/out"].first
    bash_completion.install "#{out_dir}/btm.bash"
    fish_completion.install "#{out_dir}/btm.fish"
    zsh_completion.install "#{out_dir}/_btm"
  end

  test do
    assert_equal "bottom #{version}", shell_output(bin/"btm --version").chomp
    assert_match "error: Found argument '--invalid'", shell_output(bin/"btm --invalid 2>&1", 1)

    fork do
      exec bin/"btm", "--config", "nonexistent-file"
    end
    sleep 1
    assert_predicate testpath/"nonexistent-file", :exist?
  end
end
