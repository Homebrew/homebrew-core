class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.10.0.tar.gz"
  sha256 "54dd396e8f20d44c6032a32339f45eab46a69b6134e74a704f8d4a27c18ddc3e"

  bottle do
    cellar :any_skip_relocation
    sha256 "b73b3750305ce75d86af0e7c6c31878dddd08c19fb2adc827a973f91aba74bff" => :mojave
    sha256 "4c48c3127468bab8196f54a7e5325c89c85ad2f58872a964d05ef28598bdb3ce" => :high_sierra
    sha256 "6d9585120bc2f93706a9761071d54a917c7d24a66bbcbcdcc267a6747f47d872" => :sierra
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "doc/bat.1"
    bash_completion.install "bat.bash"
    # Temporary disable fish completions due to upstream issues. The completions might not work on
    # some systems. See https://github.com/sharkdp/bat/issues/372
    # fish_completion.install "bat.fish"
    zsh_completion.install "_bat"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
