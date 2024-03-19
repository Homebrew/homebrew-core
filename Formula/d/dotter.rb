class Dotter < Formula
  desc "Dotfile manager and templater written in rust"
  homepage "https://github.com/SuperCuber/dotter"
  url "https://github.com/SuperCuber/dotter/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "b017b8315a76bf62b2e8e65217d487ad88b73fc18110a679076e6ad6e3936c40"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1c35084b7ba1abb154894fe9e9b1a506e53d28fa56765b0c03bc35b2b488ef0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7ff409cd90305361cf4aee3f32a68d73dab3844969e3c3094c2b6ecf954dcd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "615b61a78a9be4e1e4f4009472ab6aec0a188b6bc502f8caa070f7750e6f01e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e4164fb88b5add7a60295198cccd20afe9793be5e9b11f92092abd62825823e"
    sha256 cellar: :any_skip_relocation, ventura:        "d6c4219c85e3c50f28f1eb1fef1f8a59fb6e2def447829020f4a3223c35621fe"
    sha256 cellar: :any_skip_relocation, monterey:       "56c6af164180dbd1f6d6c39356f8107228312b97529f959d844c2d803876cc5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c254c61f9b193c7c01e70c1c2c83919d19eca429b79ed090f1dd7c5f67c8112"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"dotter", "gen-completions", "-s")
  end

  test do
    (testpath/"xxx.conf").write("12345678")
    (testpath/".dotter/local.toml").write <<~EOS
      packages = ["xxx"]
    EOS
    (testpath/".dotter/global.toml").write <<~EOS
      [xxx.files]
      "xxx.conf" = "yyy.conf"
    EOS

    system bin/"dotter", "deploy"
    assert_match "12345678", File.read("yyy.conf")
  end
end
