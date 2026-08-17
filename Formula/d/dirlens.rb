class Dirlens < Formula
  desc "Project map for filesystem structure and code intelligence"
  homepage "https://github.com/igarinpiano/dirlens"
  url "https://github.com/igarinpiano/dirlens/archive/refs/tags/v1.2.20.tar.gz"
  sha256 "792addc7c014908361a1371a4b6fecae5866a4a3bd904395e34bb6205639cdce"
  license "Apache-2.0"
  head "https://github.com/igarinpiano/dirlens.git", branch: "main"

  depends_on "rust" => :build

  def install
    cd "rust" do
      system "cargo", "install", *std_cargo_args(path: "crates/dirlens-cli")
    end

    generate_completions_from_executable bin/"dirlens", "--completions"
    (man1/"dirlens.1").write Utils.safe_popen_read(bin/"dirlens", "--man")
  end

  test do
    (testpath/"sample.txt").write("hello\n")
    output = shell_output("#{bin}/dirlens --agent #{testpath}")
    assert_match "sample.txt", output
  end
end
