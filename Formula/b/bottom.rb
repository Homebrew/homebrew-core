class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/refs/tags/0.14.6.tar.gz"
  sha256 "ec899586164423377ceaf0d15975b8cb4430e47f3c84db0394411048755c1412"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0442b5757c8ea21b20e17a5b2d5b723456e57276594ddc70f758e92d7dfd4a7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c502c52169c8f5e6bab05ab7b367adb1b4668493ae2720d7ccceef449acb43c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e33915c0cd828a315b716dce629f5969f9f461e70ea3633bdc22c5964bafd146"
    sha256 cellar: :any_skip_relocation, sonoma:        "b400c4f8409e31c637f322895ae0976b71c6df72dd08cc64691d70e2d8e84415"
    sha256 cellar: :any,                 arm64_linux:   "063c32f43d2280c3acfdb755b359092bf72a684afb00be471adff83ee8b6fc20"
    sha256 cellar: :any,                 x86_64_linux:  "d7757f739709e6c6531387de36ca0aa1dbd0e653970622c68b737ecfd77536be"
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
