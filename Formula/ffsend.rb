class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.62.tar.gz"
  sha256 "3e227caa98fbc5dcfef10f5ade375f4f12b6cb1a00f6e80cd791da32686cce46"

  bottle do
    cellar :any
    sha256 "05753174f3538f21642ba0b1749d8f8e69ecafb157aae2fd023aaa6803b8c34b" => :catalina
    sha256 "43ce51a4bd98f035ecfa55ed4e0fdec9de84512cc74c75b14c216a1605257955" => :mojave
    sha256 "ac439c2e83f9a84436fd1a6155e249bd82f9b778594914c5c6e02ffe83ad26f3" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

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
