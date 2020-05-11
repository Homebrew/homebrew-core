class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.15.1.tar.gz"
  sha256 "6f64899870bb16abd82a86c6a34c165f78603514e6ebb8ddf920b59095eba57d"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf23ebb66078b8a02236dce0d10792d1f27a7683853702ced404ac25857bf815" => :catalina
    sha256 "ae0f2d5568a547176cb6f7998cf5a2cb29aa51575a272210b02bd000fe8f2d45" => :mojave
    sha256 "799c255bf21723f2388e24c07a39ecedd528d9cbfc2c1aa2ca7681c9ae15efaf" => :high_sierra
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
