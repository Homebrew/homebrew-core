class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/refs/tags/0.9.6.tar.gz"
  sha256 "202130e0d7c362d0d0cf211f6a13e31be3a02f13f998f88571e59a7735d60667"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "339ebc558e1c566eb3a94a4324a7c96af8ce9c07f21434b09e56befd17cfa1b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "230f9e676ba5fc701d5c0d12fc34f52502a702979b4eb98875c83463bc3d3112"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b155becba57f4f76d8009b4686756a5c05b914995d4fc2277f1a79dbea5728a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32282051bf83138932c9ffb44e2cfcd3a09683bc25520949ccd21cf3273f83e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "d20d96b8966ea09a734964402ac336644d76b8203025078eea30d175886b777c"
    sha256 cellar: :any_skip_relocation, ventura:        "62d753583c35328b6d5c0360bc58b0b2e148a4d09f123acf5f68754227d93712"
    sha256 cellar: :any_skip_relocation, monterey:       "7a2edf54adea53d8210fc39a6a82103b125fc801a24111c4ca4ba6b8262c8046"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4b7fcbb96e6a1adfe8f5e0afc177ac04f4c9114be1c16b270c240e77d30ce5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cce0e8c30968637538771345087ad22e91704f314f585cc8589ff7b727a39125"
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
    assert_match "error: unexpected argument '--invalid' found", shell_output(bin/"btm --invalid 2>&1", 2)
  end
end
