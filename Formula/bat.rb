class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.15.3.tar.gz"
  sha256 "5880d3c25a964991ae573f3059b432c13f7e97530e2e28aa25ec2d4a06f6b926"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b9842543662a8ed7301c5a4247c3adb12d07913e328322d26355e0696462e79" => :catalina
    sha256 "e0a823dd1769d4abfeecdb2884951759e4d3a0a9a7bf5441250f6c8a93cda3d2" => :mojave
    sha256 "099bb1e8ebd4eb7a948e8a8b9cf84cec422ce4cba4f11426ae02dcd28f2559f7" => :high_sierra
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
