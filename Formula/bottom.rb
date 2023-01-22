class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/0.8.0.tar.gz"
  sha256 "0fe6a826d18570ab33b2af3b26ce28c61e3aa830abb2b622f2c3b81da802437a"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b79ed696553f9a85390ee4f45f3555306259ea5656cd98f9376620e45bd3a79c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2382c02baa05f338df9bc720a7319fc4e37bc489b453349ea131523839aede0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46157f3a5ed4cd8de8ce6a69d2351d541878d2da6028848f94a4a78d5705bea7"
    sha256 cellar: :any_skip_relocation, ventura:        "e669ff64ef5510b25daff197dc7d87755d01fc055769452dfeaad20bbcce07a3"
    sha256 cellar: :any_skip_relocation, monterey:       "921216b193d93fc8943786a231359b61356f325a222b11ae39fad78f5aeaf048"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb8b854edbf795437eb67f5f9147e497ba6bd2062cf14055628cebcf92ce9020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8e7b2bd33adc65df53c323952e8779797c1aae39932e84056d32bafea25aedf"
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
