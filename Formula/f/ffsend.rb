class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.76.tar.gz"
  sha256 "7d91fc411b7363fd8842890c5ed25d6cc4481f76cd48dcac154cd6e99f8c4d7b"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dc95f39cd9bb2f8baeb56317a533574ca1131c7194d520de67f1db735de0cae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f63f21a83b7dc43a87be7967553bd47609f9312e757c6f7507794db5cd8bdc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d62f3d93e561b4650c6c114cb94e4dfc32c5d3ca6270177b92096f13c8a6a049"
    sha256 cellar: :any_skip_relocation, ventura:        "0bcba3c1fb284510e939769c87c65dc6d8a133398862c3b2fa0dba5615ab86d7"
    sha256 cellar: :any_skip_relocation, monterey:       "8c05334fa4eff966e49b299a2ed37b40c96c75536c40c41ada9153db20a97154"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e04f2de4d511942c43918b56d4e332e35afeb62f91241e07f9586c08c3ef785"
    sha256 cellar: :any_skip_relocation, catalina:       "a654b06bcd03da8833f6effb8d5ace4315bcc4942d4c7bab2fa947a295367b15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "529ad4316bd7047a2261b662630cea1742b5749bfd2e66d41c2272775a6ae51a"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
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
