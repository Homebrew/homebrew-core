class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.17.1.tar.gz"
  sha256 "16d39414e8a3b80d890cfdbca6c0e6ff280058397f4a3066c37e0998985d87c4"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2154428e50a347937148312bd787b422fd21b1135b58bf9362aebd3ea08c25d8" => :big_sur
    sha256 "48a05609d5738b5f9fd8c886aa9e6915b2ad7e0a4148979a026ca157b6e8e199" => :arm64_big_sur
    sha256 "37950cb2429346cacc2dd0a9902b71eb958fb9531114d3606bdc3acfdd4dc3c2" => :catalina
    sha256 "9f4df3e3e829e59ec2d196be8a494d60f9f68ef7f9f769adfb018f75148677be" => :mojave
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    assets_dir = Dir["target/release/build/bat-*/out/assets"].first
    man1.install "#{assets_dir}/manual/bat.1"
    fish_completion.install "#{assets_dir}/completions/bat.fish"
    zsh_completion.install "#{assets_dir}/completions/bat.zsh" => "_bat"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
