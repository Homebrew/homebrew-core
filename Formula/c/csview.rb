class Csview < Formula
  desc "High performance csv viewer for cli"
  homepage "https://github.com/wfxr/csview"
  url "https://github.com/wfxr/csview/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "ff796fec2757186133c8b61caec8f774c44cb8e1400d014a29930601760e6a36"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/wfxr/csview.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17f33e1d5bde8ba2054bbb5d91c14eeab31c14ae39348797e8961fe5d1f4ea53"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d25d2aea7486a2a31b379a548c8e4b114f18248fb5dfc7d837ed0f4adb8019da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1463bff091b602ba9ef0c95d2c3afb1e20867e7392685970b919a678db4ca13c"
    sha256 cellar: :any_skip_relocation, sonoma:         "415ac9cfed6e73b9ab254354ae04dc65fa3f467be730799b19a6594ac363ce00"
    sha256 cellar: :any_skip_relocation, ventura:        "74cb42bcd0226d14c0edf923673a068dea863d96f9bd259e0521cc178720b1d4"
    sha256 cellar: :any_skip_relocation, monterey:       "8604e14ddc8e3b4f14252c22f1477d1873fae23d7e074080c01407042959d667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "166893e081b88e59f1443f9151b75c484608b463d5e7f5561a31e9bb8d114251"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    zsh_completion.install  "completions/zsh/_csview"
    bash_completion.install "completions/bash/csview.bash"
    fish_completion.install "completions/fish/csview.fish"
  end

  test do
    (testpath/"test.csv").write("a,b,c\n1,2,3")
    assert_equal <<~EOS, shell_output("#{bin}/csview #{testpath}/test.csv")
      ┌───┬───┬───┐
      │ a │ b │ c │
      ├───┼───┼───┤
      │ 1 │ 2 │ 3 │
      └───┴───┴───┘
    EOS
  end
end
