class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.15.3.tar.gz"
  sha256 "5880d3c25a964991ae573f3059b432c13f7e97530e2e28aa25ec2d4a06f6b926"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c5a5e452cfcb5ff73cfba5a8f3d4ede31152c6e0f9b2bcdab84d5307ce3a817" => :catalina
    sha256 "c179a22a6cc9ef85b29b29961112c1e97ced70683d75ad1f2e303fdb8ad76fde" => :mojave
    sha256 "0ab5ae230c60ee8b103ea03c607c4532b6c234cac59eb137a1898fa934ef4db4" => :high_sierra
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
