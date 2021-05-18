class Intermodal < Formula
  desc "User-friendly and featureful command-line BitTorrent metainfo utility"
  homepage "https://imdl.io"
  url "https://github.com/casey/intermodal/archive/refs/tags/v0.1.12.tar.gz"
  sha256 "cd62894e519dc5aa0284a5f48aab86e1a45c3bc96b8a5481741adb6960d4751a"
  license "CC0-1.0"
  head "https://github.com/casey/intermodal.git"

  depends_on "help2man" => :build
  depends_on "openssl@1.1" => :build
  depends_on "rust" => :build

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    system "cargo", "install", *std_cargo_args
    system "cargo", "run", "--package", "gen", "--", "--bin", bin/"imdl", "man"
    system "cargo", "run", "--package", "gen", "--", "--bin", bin/"imdl", "completion-scripts"

    man1.install Dir["target/gen/man/*.1"]
    bash_completion.install "target/gen/completions/imdl.bash"
    fish_completion.install "target/gen/completions/imdl.fish"
    zsh_completion.install "target/gen/completions/_imdl"
  end

  test do
    system bin/"imdl", "torrent", "create", "--input", test_fixtures("test.flac"), "--output", "test.torrent"
    system bin/"imdl", "torrent", "verify", "--content", test_fixtures("test.flac"), "--input", "test.torrent"
  end
end
