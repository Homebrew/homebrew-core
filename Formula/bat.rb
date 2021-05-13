class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.18.1.tar.gz"
  sha256 "ab5246c3bec8745c14ca9a0473971f00fbce2fdc1ce7842e0a96676ee5eac2af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9bbb0e82789791a64d355373fe297f0f4e3cffa229583a352d34a2b5e561025e"
    sha256 cellar: :any_skip_relocation, big_sur:       "3665b461a7e64ff8fbd67d64ee43b1f59446087c9551b78954713602d3c0a67d"
    sha256 cellar: :any_skip_relocation, catalina:      "d69cf5c91d2b62c76dd9e61a6fc68c6cd8c132dee4505af4f3f8677dd056436f"
    sha256 cellar: :any_skip_relocation, mojave:        "ec1adbd7c9a6921dce69e7a538187f38a178dcd755c153cd9721d3603f052050"
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
