class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v6.3.0.tar.gz"
  sha256 "b178ea3018667766540a54703b15f01207f4626bc7162378a86972f2f43f2f60"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    sha256 "c158ecc19b7c82b25dd0323f4b4ee8fb958c6d3a9a0271c2c17817b9ce1db8f8" => :high_sierra
    sha256 "e054fc838b6d55ed994e1905ec774ab7148681eda9edcbdfbe9cb1a06074653a" => :sierra
    sha256 "726790c1c0826cda118af469068c69254f2aca036e60a901b93bcd77ff0eb3c9" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "--root", prefix
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
