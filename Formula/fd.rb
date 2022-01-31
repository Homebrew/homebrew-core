class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v8.3.2.tar.gz"
  sha256 "9cc2354c652ee38369a4ce865404f284e94fa9daf043bb31d36297e7a2d7cd45"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a9b6670e3898d06da79c8da5405d4409141c4df1b9db3fbf2ffa56ecacdee2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd2878985b2f4100c897283744826acdca627a57692ba11d3472e203015df3d8"
    sha256 cellar: :any_skip_relocation, monterey:       "544bd266bd9d4689aeea459d5edd822db269647074bd28c682c58ab097dcd13d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fda49ccd4fb859c6b040695f69e25dd2571e631c7fb203465702c85f924ff755"
    sha256 cellar: :any_skip_relocation, catalina:       "492097b85cf2fe8b79700048510c90e4da55fee307552e143e84fcefd3bf552a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22528c35f36907d807a44daf4dcd5c8d4c3598a55e3d73df68059ebe228e0b10"
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
