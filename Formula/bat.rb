class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.14.0.tar.gz"
  sha256 "5e0f8964b32764886bd03b737f25429fdead9151946348a712c2b773c1c43ebe"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d4d8e88d1ebff5c953dff489973597015cb742a89c8c102e79f8598e239f0c9" => :catalina
    sha256 "044cba23fd3e9a556a27cce1a61db22d854f46a11fed5f04c244873cd9a273ac" => :mojave
    sha256 "d755b9524e5ad50d9bbf687ee1e42697d9c39c95bb2edfbffd7c6d82c78dfb6d" => :high_sierra
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
