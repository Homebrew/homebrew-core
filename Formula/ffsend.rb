class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.68.tar.gz"
  sha256 "749046507274f03a1e667cf2302b5b3ac2a977e44ae3f9594be65ce0fca40daf"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb967f89f7dcbaf1017a23b31ca538411d584ea900992bf1bfa3ebe3097afa41" => :big_sur
    sha256 "0f95ad0452a8534e628485f3c049813c133cfe0c24e41c467c85e4b6ece2e335" => :catalina
    sha256 "d68e8a1fe45f28ffec5d113aa32d107a3076020a7e52726d91f2316ea6dd65a3" => :mojave
    sha256 "c5ddd8dadde02073f8d3daa7563ce3b770f0305bbcf1bd3b440be7ed8f72e8ed" => :high_sierra
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
