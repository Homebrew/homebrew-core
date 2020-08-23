class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.15.4.tar.gz"
  sha256 "03b7c8ad6221ca87cecd71f9e3e2167f04f750401e2d3dcc574183aabeb76a8b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae2c26d25a0dac35bd839a091f89201b5d9eee32ef613325426c7e8b8812d1a9" => :catalina
    sha256 "40dea8577c06a08d3e3bd20a949245ff02ea85153d25f72a65cee03c1b1e1cf9" => :mojave
    sha256 "59bed16f8a4741a9d92f62cb7c9965d1abe40dc5dd2323bc4f37e71330b1abf2" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010
    system "cargo", "install", *std_cargo_args

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
