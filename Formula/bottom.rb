class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/0.9.0.tar.gz"
  sha256 "0b5ba825905748a6146307517cf5e148bbc7ce13070a8448cc2d38ee68c1a42c"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed7495b383b13e4f269623a9768ff49392e27cbc5f53ba64ae6a861aacc26bd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7df8fffb35e9a263137212251cf13b9f40790f4a44e02fbabed3f451bd1a9157"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c660ba1e659b34cfcc1c429c9ab1f6280241e47be36600709307e6d4e1edb48"
    sha256 cellar: :any_skip_relocation, ventura:        "c1a4c7aa18d28d0134cb8c7503340ffb23c00494b5743088419b84dc79461643"
    sha256 cellar: :any_skip_relocation, monterey:       "d5629a58edfa142420bcd5f0507014afd6bc5254c2803a423a5667708cb71c6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "56a02d8db9872192cc0e097b6e67f76921e14fde21945b07bd81b5cd767a7551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2925fc0c9fe043800039ad2db7fe19dd30bb236eb196fcc054aa8440e4396692"
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
