class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/refs/tags/0.14.8.tar.gz"
  sha256 "be10adada9ec1e5dd741dcb5581c4e0ebd45cb5bdae213dd296b29511363a770"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34fb4e5dc5baf966d20ad88e84dae0f8d35c97e83739df57a5a0521b756c38db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a24ec39fdf3edfc05b709d80a516751a2bc682247022dbc69b9d0c29b61f5971"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98d893a895f6bb91da2f06f1bb594a3beadcd512da46d3fca3e35c523e4dd41d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e709afacc7f13da3221b0fe04c4a14cad5b35a005cebce3bde7a25d8ae82c76"
    sha256 cellar: :any,                 arm64_linux:   "f0633f9c4cd5dbcdee3170ffbea53834b618ff99d4624259b1591d071ab0be73"
    sha256 cellar: :any,                 x86_64_linux:  "67422dd47bca387afaeca0e16cbea1ae3582dbd57145138cf4fde35123d5c13f"
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
