class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.15.0.tar.gz"
  sha256 "702b330d2938426679b3b0d50334b1518b4fb1d779220f2e32e68dfa1bb9fc0f"

  bottle do
    cellar :any_skip_relocation
    sha256 "54e9029fddae20b738e35cb9d88b4b03ed0d3d0a2e8c874d3a1a83ea1531464b" => :catalina
    sha256 "16026e7889c58f5841a6da727a182ba3a5a6829ebccf7fedecb472bb5a9c0c47" => :mojave
    sha256 "5d52756cca5a309cbf1027311ac74b187f78f839292f58645d615d4c0e874fc4" => :high_sierra
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
