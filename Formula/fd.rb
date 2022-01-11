class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v8.3.1.tar.gz"
  sha256 "834a90fbb4e1deee2ca7f3aa84575c9187869d8af00f72e431ecab4776ae1f62"
  license "Apache-2.0"
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37d188ef19f58b147cc1d6595a603f89a263bde250760eda1322a65de7000593"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4b07d3a35de750e38b4b98db2b726877cf14610613cbfcd1352bec17d20009a"
    sha256 cellar: :any_skip_relocation, monterey:       "af8df4d53750487feec0e4bebe3ca100fd6599c73c0886b48dcf9f782dedbdd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0dcd1d843e46f29b190433eeadf21a69426ce690468bcd57fffdc94b14127f8"
    sha256 cellar: :any_skip_relocation, catalina:       "d679cce27ea0258006a7b58b813b899c1cc9da5c3e4b4339ce7aaf723c139663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "439a1e0aaa9df8e3ab336e8e76d6d0e8d2436b6b1976396b303622d850d33ad6"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    man1.install "doc/fd.1"
    bash_completion.install "fd.bash"
    fish_completion.install "fd.fish"
    zsh_completion.install "contrib/completion/_fd"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "./test_file", shell_output("#{bin}/fd test").chomp
  end
end
