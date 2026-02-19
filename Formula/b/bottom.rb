class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/refs/tags/0.12.3.tar.gz"
  sha256 "1c70894f0eceb7034075959ff3080cf4706c11d7c012912c24e777abe4e62b70"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a02813cfb7ca84b845f962deead91139eed67c2bbae957324542893d94e6368"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e69cf8d61670780996c1f3b284f9ec4d80824e99104f60a54d77df4f8797ca7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38e0d26e3850e0cc1cc3efd218447951bc29036dacbd77cbddb84e123c0a0651"
    sha256 cellar: :any_skip_relocation, sonoma:        "c76de8e325b1aff84e084aa957c2f9b265d69334ff892958d1dd0a3e5f34aeae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bedc68cfbb094ff38f13238f5962d8945d18820bd5478e4feb046d4913ac9198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f36dfcc415534dc27bea91f8b8748875b56481733aee085df9e47752822d1af5"
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
    assert_equal "bottom #{version}", shell_output("#{bin}/btm --version").chomp
    assert_match "error: unexpected argument '--invalid' found", shell_output("#{bin}/btm --invalid 2>&1", 2)
  end
end
