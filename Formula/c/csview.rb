class Csview < Formula
  desc "High performance csv viewer for cli"
  homepage "https://github.com/wfxr/csview"
  url "https://github.com/wfxr/csview/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "de84f181a6b89101ed150a378eff9583d8f8cbcc4025d06adc4bc3c48085df95"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/wfxr/csview.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8341aac84bf3742c76c2a4e869f76de7b45b89a058d1f864b26f81a98e5bccd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55c57ffe5e4de2111bbdcfcce022b99415fc892547c593d6111426226db06321"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1383555c54c01abbd0a2338b1c6434240a1fdbd2a185acc82fd90008c07a447f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfc7e3e335b6dd3079310a339fcc7d71df6fdfb522db1dada174940504e64996"
    sha256 cellar: :any_skip_relocation, sonoma:         "610bc3a181d58402bc7b70a296032bbb774446175f90f52346a9e3438720db41"
    sha256 cellar: :any_skip_relocation, ventura:        "cef9950a72034e572b6bc7b02d688ad0c2cbfbd2732223d7853714c91d335c1f"
    sha256 cellar: :any_skip_relocation, monterey:       "14dafba5b224e069fd7b0ccadaae032eacea098b46c43e2ef56fcfb1be9be2ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52f4ece6bbdd1cfb6b61ffb0ab44b6ad72b426479cf8612d7dfa6d5fba816a57"
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
