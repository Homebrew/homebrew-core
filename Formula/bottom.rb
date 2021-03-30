class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://github.com/ClementTsang/bottom"
  url "https://github.com/ClementTsang/bottom/archive/refs/tags/0.5.7.tar.gz"
  sha256 "49e01a2930d913dba2a1329389faddb4b3971a6b0c08f7482d2759475d5cc27c"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git"

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    target_dir = "#{buildpath}/target/release/build"
    bash_completion.install Dir.glob("#{target_dir}/**/btm.bash").first => "btm"
    zsh_completion.install Dir.glob("#{target_dir}/**/_btm").first => "_btm"
    fish_completion.install Dir.glob("#{target_dir}/**/btm.fish").first => "btm.fish"
  end

  test do
    shell_output("#{bin}/btm --help")
  end
end
