class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.74.tar.gz"
  sha256 "e6092fc4f40be6d79ddf46a0fb4a739310a2db5407fd3f5db2c43cafc8c41485"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b53cd1075514afca5d97f9132b1abdecd1c6e0da8085493572084c0f4924e00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb28f76fd8ce6bdd41178a7c019b74a181bc10c6af7bc4577c39f42cb8a5aad4"
    sha256 cellar: :any_skip_relocation, monterey:       "03593e8ec608b4906bd3e02324fb8ebb01fec7f6f346f66c2adcb48d3b2b48cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0cf6c1a3c746a12a9fb654c772ec117378d63acaa9027811641a7ce81493f2d"
    sha256 cellar: :any_skip_relocation, catalina:       "17e152eadf259130498d4b99008244646fa13d5ab35ca55998dbaa587b39283b"
    sha256 cellar: :any_skip_relocation, mojave:         "8721d410afecbffa858783fadedc162294924ea4aba35ba0c929956df7bbe899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1eaeb9b9f408a6a0766c84fe6cc7bfada070b859a9a66c36dff3d80b7d198b38"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "contrib/completions/ffsend.bash"
    fish_completion.install "contrib/completions/ffsend.fish"
    zsh_completion.install "contrib/completions/_ffsend"
  end

  test do
    system "#{bin}/ffsend", "help"

    (testpath/"file.txt").write("test")
    url = shell_output("#{bin}/ffsend upload -Iq #{testpath}/file.txt").strip
    output = shell_output("#{bin}/ffsend del -I #{url} 2>&1")
    assert_match "File deleted", output
  end
end
