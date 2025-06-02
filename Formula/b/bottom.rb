class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/refs/tags/0.10.2.tar.gz"
  sha256 "1db45fe9bc1fabb62d67bf8a1ea50c96e78ff4d2a5e25bf8ae8880e3ad5af80a"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "293b085af54d7e69f159e9b6a1a317ea380d52cc2996bbf74203971cb2fa6347"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c90acf12752aa008cb245f0f5e6982ba391b4129b0f1372d2f651b367768f90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc76f47d4eaef7e6eac3cda67cbb06805b049ed83b0c7d7f3121a0ef3f9486dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a50cf59e7195ba6cc6c24778047b1681e1932625222c4a3d19f386e315366737"
    sha256 cellar: :any_skip_relocation, ventura:       "eb73f6318589bc6be3e01d7eefd8a1cb4e19726be7f2f14cd8e574d2d86333d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9dabacfbd8ccf889af78707abb7c5dd70dbfcde0a1b2501e9a67f0a9e1f14a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f438b63dce811a4d60b306a712385942acec74e726101dc8ab78b910ced3a2e"
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
    man1.install "#{out_dir}/manpage/btm.1"
  end

  test do
    assert_equal "bottom #{version}", shell_output(bin/"btm --version").chomp
    assert_match "error: unexpected argument '--invalid' found", shell_output(bin/"btm --invalid 2>&1", 2)
  end
end
