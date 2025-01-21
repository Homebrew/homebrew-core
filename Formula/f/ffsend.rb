class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/refs/tags/v0.2.76.tar.gz"
  sha256 "7d91fc411b7363fd8842890c5ed25d6cc4481f76cd48dcac154cd6e99f8c4d7b"
  license "GPL-3.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf310e7b4721b1e784f174831c9d1c0338db34c809a7ec7a59ad2fef07b7a761"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "074ac3f31ccdd07ac55c0572b01945cf50300b9459b6c28876a09a7d78fc7ea7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bed1b2a2e6d425337d9b27e6ddfe2a00a56a73d2e75bc2e181368b8626bd07ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a3d98ac10ca71571355d00c738aa9ae6e3b6b5962278da5256c0c5bb6ce87a4"
    sha256 cellar: :any_skip_relocation, ventura:       "26c6f0ecfebc1f880e894140c43ba945d8463de740be410de28f7288b0055f5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65b43d242c8b518fa7650eacad3c98420b8be9d05d9fbb0ba9d6a53f6d205c7b"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "contrib/completions/ffsend.bash" => "ffsend"
    fish_completion.install "contrib/completions/ffsend.fish"
    zsh_completion.install "contrib/completions/_ffsend"
  end

  test do
    system bin/"ffsend", "help"

    (testpath/"file.txt").write("test")
    url = shell_output("#{bin}/ffsend upload -Iq #{testpath}/file.txt").strip
    output = shell_output("#{bin}/ffsend del -I #{url} 2>&1")
    assert_match "File deleted", output
  end
end
