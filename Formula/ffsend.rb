class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.67.tar.gz"
  sha256 "a2ae6816b9fd53d88cd2b866d9de7dee0ccd00ebb3cb14c35f975a28224e8ed1"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f457415506e1b49b8e600abee3ff1d7d7e516a93457c0fbd3862998637592ce3" => :catalina
    sha256 "e367f461296fc64f3a39a3d3b7101e09a9788a5d7dd50e3f0f4e2cc83a8e66d0" => :mojave
    sha256 "fc5facbea4621222b4f68df72ef468c0ccdb84fd14ce077f79d392b7dcbd434b" => :high_sierra
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
