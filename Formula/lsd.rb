class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.23.1.tar.gz"
  sha256 "9698919689178cc095f39dcb6a8a41ce32d5a1283e6fe62755e9a861232c307d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12f7c0889cf4a5c18fd04f0dda7dac2af7a7c6aafc2a16ce2af4a76d28fc50b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "657141d387cf3185c8e33a5730c13bf4ff600c35dc2b4ed7bb0c5d6bdd99501c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb9f63aab186e0d6b231eae5cb7800976a06d4f44265b415b082b6996c1f0c38"
    sha256 cellar: :any_skip_relocation, ventura:        "603348a70cb1484053c8732ecfffc96920177770dbb84f791e9ac3be23e26cf2"
    sha256 cellar: :any_skip_relocation, monterey:       "0303125c2efa21b60105d8d576d032b2248e14deb7198b5bcb55a2bd5e58d4c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cb90516594836c18243d8e799e88339e420735d2fb5c8182a4e3b78c83103cf"
    sha256 cellar: :any_skip_relocation, catalina:       "5f105e34087e96b5fad8f62d69fb8b212f03501a526420415871fa2326a5f570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20fc3d18113e6fe56c387d1d3443d8b6dbf6888e07f53b90c9d8266e0048680d"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    bash_completion.install "lsd.bash"
    fish_completion.install "lsd.fish"
    zsh_completion.install "_lsd"
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
