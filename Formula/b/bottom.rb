class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/refs/tags/0.15.0.tar.gz"
  sha256 "9b38fd551ef9e67bb8dc09a658e7c9594913fc5c43154f264d5b776416ad1c4d"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a1cb6e27476216833e1e8263d381f4b721125c838b3e1c6ca403fc3c515812b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c9e84aeea6b89def7fd3d56d00de7e8d4060d8777ef6d5af0af9c7f14a6534f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "23a62bc24a45b35fa1ece605c5f794a3c865feee54ec367cd329ac1653fc0d92"
    sha256 cellar: :any,                 arm64_linux:       "86956acff4d762328b669d2057298ac229449d01d5c4fce21299a938459c63ce"
    sha256 cellar: :any,                 x86_64_linux:      "091a1ce4bc50de72a4d5d15f52645b16db63ede897b94f66fb575ca027c0444c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
