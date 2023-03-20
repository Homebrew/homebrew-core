class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/0.8.0.tar.gz"
  sha256 "0fe6a826d18570ab33b2af3b26ce28c61e3aa830abb2b622f2c3b81da802437a"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0788ad1a4609135faa464e0f8413b27d35a949c5972ae04c02044ee4d2c1ce86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea03bf813320482b018399581d37ab74f29287889477b0adccce96364b8d3e54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "670f24f20f4d41b43ee6b53b2ce09419a113a8393585fde17a9ceac30967454d"
    sha256 cellar: :any_skip_relocation, ventura:        "0f1e73d968b11da7a5bb6c849401c2652dff9ab8059ec5d5bedcbd102daa0407"
    sha256 cellar: :any_skip_relocation, monterey:       "1308aad09f484fb9f5c5871aa2075b56cab97a5176000db3739a3f40c876fbb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c14b1a88e02686a45006d249547c200a91b7cc84002cb6a4a210b8a2fa7db51d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b10cd68c09569b63a5c6804d14e25bd248efaf716dec40b0a5303832f32100c"
  end

  depends_on "rust" => :build

  def install
    # enable build-time generation of completion scripts and manpage
    ENV["BTM_GENERATE"] = "true"

    system "cargo", "install", *std_cargo_args

    # Completion scripts are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = "target/tmp/bottom"
    bash_completion.install "#{out_dir}/completion/btm.bash"
    fish_completion.install "#{out_dir}/completion/btm.fish"
    zsh_completion.install "#{out_dir}/completion/_btm"
    man1.install "#{out_dir}/manpage/btm.1"
  end

  test do
    assert_equal "bottom #{version}", shell_output(bin/"btm --version").chomp
    assert_match "error: Found argument '--invalid'", shell_output(bin/"btm --invalid 2>&1", 2)
  end
end
