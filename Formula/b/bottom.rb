class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/refs/tags/0.14.9.tar.gz"
  sha256 "1dbb940c763fb583b7e1c7dfa165b73ed9a0ba712e72cc97311c5b1c098d5b72"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "33e1500be59e17d6d6dd645aa690e424d8efc3af99afbc795b0d84c1a12e4223"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4fa0368ecda020bb628a5b04f71250c86508c06622677cac801bf8316109222f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b2aaeb7f9873cde9aa4907502af5d533bbc4e2c037cdecb5e691d530e9c4514"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b8b5d5d8100f1994990cf75a22295eeeafecdc1495cecb4a95f4f047845841fe"
    sha256 cellar: :any_skip_relocation, sonoma:            "fb23f0d747be06af5d8331a39e4b545a31ce4315bff53ce8b65bd81fab562973"
    sha256 cellar: :any,                 arm64_linux:       "5f462b94ff3b7571c84db0e54bc782c5e40f02644d5bdaf34453e882e5450b04"
    sha256 cellar: :any,                 x86_64_linux:      "138de23f6c2e50e839c9d6be824fe7d07aeb85dc80de8651cea72c882d07b400"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

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
