class Ccval < Formula
  desc "Validate commit messages against Conventional Commits rules"
  homepage "https://github.com/andrey-fomin/ccval"
  url "https://github.com/andrey-fomin/ccval/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "8a87eb7619bf17639ed00cf7ec3fd505a4f17d08141d14c33b687dac0931cfa7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    (testpath/"good.txt").write("feat: add formula\n")
    system bin/"ccval", "--file", testpath/"good.txt"

    (testpath/"bad.txt").write("bad commit\n")
    output = shell_output("#{bin}/ccval --file #{testpath}/bad.txt 2>&1", 2)
    assert_match "Missing colon and space after type/scope", output
  end
end
