class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/0.7.0.tar.gz"
  sha256 "54b5118499afe5935cd95ce42174288f0f50a67d6051fb160ac25ff60124800f"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1ff37a97a0798737e38ce3f1dfc8b7f3667ec28e400d799a5e11a338984dd35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a06a086763f5d9eb759035614c87f326ad5a77f7070465da9c4f2148ae7ae7fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e957ae292d89de8535f92d870260529c84889e1559e7bf2ca33ac206e38a0bab"
    sha256 cellar: :any_skip_relocation, ventura:        "8c4edf12a6e344ff622550a269a1185361e2de56971781d91ed8121efd87b091"
    sha256 cellar: :any_skip_relocation, monterey:       "abe1c56d2a1a949284b716baefb0bb15a5262097ab4b8e52b30145204d7d22d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f91e743720c1b39e586315b2a1311931a1f81ebda6841b2c8306c19e3ae20620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0185270c1a21c94b1e0a81474d573f4284dad735ef1868a95a9850cffbc727f"
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
