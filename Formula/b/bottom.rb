class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/0.9.4.tar.gz"
  sha256 "199123ef354bcabaa8a2e3b7b477b324f5b647d503a2599d08296733846eea6e"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6d1ae0fdc270d7223157fd4bc4a85526f435f8270ea5c58133eba86a6c2d739"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2e89ac75734da0d6ee62d871fa9bf711c644dda1fab64fa39377c1be8ffdc1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d82cc50578862e77cb82eb6e4175c2575f818a250313a3a8e50834611641b88"
    sha256 cellar: :any_skip_relocation, ventura:        "dccc5831e06f247363b2245f7e5f546abf00a206192b652aa26f1f3f643718ef"
    sha256 cellar: :any_skip_relocation, monterey:       "4013f5654dd00efd5397e640c2497faa48a243150a02a1d699e0258450ce66df"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0e3fbd4f415d15f79e298f25fd788f10d9714087090a3a291a668d50296ae7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90cc3fd16ba040803e95a14ab5dbdc92e1ba40921c8ef32d22a2fa9c8617a852"
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
