class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.16.0.tar.gz"
  sha256 "4db85abfaba94a5ff601d51b4da8759058c679a25b5ec6b45c4b2d85034a5ad3"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "379f270756652f684da4331f9148997647f3f8a71822d21847ed283e92aba260" => :catalina
    sha256 "b8e3de0b9a50a3b91b3e2dbc5b6d7653b4be9d8f42e3df03db6ea3bba6645a81" => :mojave
    sha256 "e26f6e0dc0460cfb0e91279308ca1162a08aa816869edc289cb80572ce5f3426" => :high_sierra
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
    zsh_completion.install "#{assets_dir}/completions/bat.zsh" => "_bat"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
