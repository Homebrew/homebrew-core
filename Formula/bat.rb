class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.15.2.tar.gz"
  sha256 "7922e03c3b9da2abe76b294ac5cda4529bce8a1974ecf1c9228f334c82c132bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "91c579ebf644aa95d80ae8d2b6933e40f6fddcaa2ae4f3bc25f256e2cf1965c2" => :catalina
    sha256 "264089371abb121af065a9e36aa922bdc9d34867f0d68c707c9f2e628e1c68cf" => :mojave
    sha256 "df070a491d0da67bce3fb30be7dd2da5705ce15bcf14f8e8101c124afe621e06" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    assets_dir = Dir["target/release/build/bat-*/out/assets"].first
    man1.install "#{assets_dir}/manual/bat.1"
    fish_completion.install "#{assets_dir}/completions/bat.fish"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
