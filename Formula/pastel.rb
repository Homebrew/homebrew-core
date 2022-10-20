class Pastel < Formula
  desc "Command-line tool to generate, analyze, convert and manipulate colors"
  homepage "https://github.com/sharkdp/pastel"
  url "https://github.com/sharkdp/pastel/archive/v0.9.0.tar.gz"
  sha256 "473c805de42f6849a4bb14ec103ca007441f355552bdb6ebc80b60dac1f3a95d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/pastel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef545e07529e6c80e4ea7f2bd830989975c787132ac3f93c160d992e9bb678c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4ea05db30166b4abe7fe175ef8374b51c744786754c67e67b0fd2f89d04159a"
    sha256 cellar: :any_skip_relocation, monterey:       "6e4b7ed3597c903ceff459d11681b400a7d22e416446852f766ac6da33f2779d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e84e13b15e9d9c6fdbc95a195db15023df8f0240cb9365000bf7712e521dd2f"
    sha256 cellar: :any_skip_relocation, catalina:       "68f44dea3226ca4b760dda2987e19a7688bd5f05a52905cb86e12cbe52b5f8a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66aada910051241294288a290ed04cd1321cf10b8a73720dbd0b670aa32f62be"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath/"completions"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/pastel.bash"
    zsh_completion.install "completions/_pastel"
    fish_completion.install "completions/pastel.fish"
  end

  test do
    output = shell_output("#{bin}/pastel format hex rebeccapurple").strip

    assert_equal "#663399", output
  end
end
