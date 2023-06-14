class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/0.9.2.tar.gz"
  sha256 "c6b1f6eefa814607cbc6f1ebf6358a070293413d09583963970d650b724a3b3a"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1feb2cbc18e4aac7256532bd10df73165adc787711566d3ca409f13bc694c172"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22f0aaa8f197085cd4f169fc972f59cc2128571bcea27fe021c7e931a06a5814"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5529193e79de83a601d0fb3713f0eb0ac9d2cfa536ce5ee4f51d865c0dc7fa0"
    sha256 cellar: :any_skip_relocation, ventura:        "3bd89bb468533c10feedce451259655f1a59befdba9f6ede0d02dc8762f939d0"
    sha256 cellar: :any_skip_relocation, monterey:       "9bf45d0c6f6b448049507143186a5b48f60362c8b66a45a768fa187159c935ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "92879f8c249de5942690245f32120166b3b7525810391b985a9985af2251aa26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "620d11518d266bcd8c77b23567e045953f3049ed0b40799fd00985f50d9c8c6b"
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
