class Anymd < Formula
  desc "Convert any file to clean Markdown for AI agents"
  homepage "https://sylphxai.github.io/anymd/"
  url "https://static.crates.io/crates/anymd/anymd-8.1.0.crate"
  sha256 "7a737e39dd573e4c0be894ae75644fccae0ea67315b1c359b4472f07d8a85fab"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"t.csv").write("a,b\n1,2\n")
    assert_match "|a|b|", shell_output("#{bin}/anymd #{testpath}/t.csv")
    assert_match version.to_s, shell_output("#{bin}/anymd version")
  end
end
