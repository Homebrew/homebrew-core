class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v8.1.0.tar.gz"
  sha256 "a58f0d74533a6e79a955c961c7228c53abfa3ca56051713be2395e56ac7212ce"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3eafb3efc4c62d824ebc316c73ca1562cb92eca8049864ae1716144969c8c3d" => :catalina
    sha256 "c6c7349e7bfbe9893478d06c7c599934c1e07e017ced1b5d13a5716487327de3" => :mojave
    sha256 "49998bf05261897f03f5026a8394c5106e83bec4eb79dcd1b0846c3248e2573b" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
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
