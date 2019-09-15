class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v7.4.0.tar.gz"
  sha256 "33570ba65e7f8b438746cb92bb9bc4a6030b482a0d50db37c830c4e315877537"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5f33efc94ca927a3670dda123b86f08c516c8cbb3c29e4ffef0a46f79a534e8" => :mojave
    sha256 "217ba35b4607e60c84970bfc6d84a665e9d19e8b5a82826550120d8cf59c09bb" => :high_sierra
    sha256 "c64ac7b88a979f3eca36324a215eab26989c15c5ee5dbfbba61578600fdf85cd" => :sierra
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "doc/fd.1"
    bash_completion.install "fd.bash"
    fish_completion.install "fd.fish"
    zsh_completion.install "_fd"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
