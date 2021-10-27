class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/v1.12.0.tar.gz"
  sha256 "2120870a97e68fa3426eac5646a071c9646e96d2309220e3c258bf588e496454"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08143e785ff6982bc64c1299aac9f16f0230850ea4e8fcb9b9728176e6c7c20a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1955b632a89c2d6a672a265f01c44905e7ea8a83f1de6989ae3076de5ebe0ba2"
    sha256 cellar: :any_skip_relocation, monterey:       "5a962e56a6de7e1290f5a178b51cf5ae827150bc3e867ef97dedbbea54de9226"
    sha256 cellar: :any_skip_relocation, big_sur:        "4db28055aefe73394c24765e35b24058bc57dfcadabccf9b991801f1716f8bde"
    sha256 cellar: :any_skip_relocation, catalina:       "051e15f3b65040b2b9dddde55881f85c2baaff8dbf36a721e3f8cdcc889182db"
    sha256 cellar: :any_skip_relocation, mojave:         "2e36e883eac7d17dbb95e053845d7e39e8d3b4f3d6013ff158b3dc01ab89a183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95f4b040d2f037e3c3a177a8b14a0541cf67929433a95228603fe26b8630b420"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    man1.install "doc/hyperfine.1"
    bash_completion.install "hyperfine.bash"
    fish_completion.install "hyperfine.fish"
    zsh_completion.install "_hyperfine"
  end

  test do
    output = shell_output("#{bin}/hyperfine 'sleep 0.3'")
    assert_match "Benchmark 1: sleep", output
  end
end
