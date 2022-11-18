class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/1.8.0.tar.gz"
  sha256 "5c78163d3ee45f838a2a69f0ac2866f901efe2a0d9e68875d1e12260951a60f4"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1248efebed76a9795ef43e1639ffa2107feff2667216871b724b5f872e08aa5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0621e167244b7b0886bf195615e4ac64dfd2f3ff33a066ff7387d198f75d7c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f19184f1e682199ab26ee1b0f05a6becf1a427aecec8503e55bf8f0517782b57"
    sha256 cellar: :any_skip_relocation, ventura:        "178bffcc765bb564d4c3ab8b9966dfaa5177708a541eeb784e8fe53a983e43be"
    sha256 cellar: :any_skip_relocation, monterey:       "db12d2e39b52779cf7c7455cde379d9d892d7e227e92149bd32c251605143aca"
    sha256 cellar: :any_skip_relocation, big_sur:        "761aa4dd71c1a9cf7af39c04272902861092902c6cad5ed9a500931655fec6f4"
    sha256 cellar: :any_skip_relocation, catalina:       "a150aedb76d6b790c18fb94a3a91041a949c7c161c0ac5465a83da50d91be692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1741fb07cad5f70a32d115ea8b7a0c7d1023a0f6611d0d01464d0dafca1ed01d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/just.1"
    bash_completion.install "completions/just.bash" => "just"
    fish_completion.install "completions/just.fish"
    zsh_completion.install "completions/just.zsh" => "_just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
