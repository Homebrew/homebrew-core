class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.14.11.tar.gz"
  sha256 "31c95fc4e9e034f9ba892397dc3d3844635c6b03852983fcf3b0cc326b751c83"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3953bbbe97bac0c3224daf93a4c34bd2b78d33b91615cd5bdefc8526ee064b3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e747ffbc1804f2adfd7605227f0e2cb5bd7cbffebd71bcbef838f82b45a1d640"
    sha256 cellar: :any_skip_relocation, monterey:       "a244115c813fc7915be106a9a6a4a9062452caea731b3b9cab50e6b245810f67"
    sha256 cellar: :any_skip_relocation, big_sur:        "51752054a7c5696dbe87a88505fc4255f89af7145cac964253987ec5ce3daef3"
    sha256 cellar: :any_skip_relocation, catalina:       "9e0c94b243e45127dca37ea67d0016a72cd895021cb5fea146a0c41cda9b037c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df29c50e75e5eb9c7cf503ecd8bfebb8689f91b56f5ade8e008be3f7c479b20d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    # The "-EOS" is needed instead of "~EOS" in order to keep
    # the expected indentation at the start of each line.
    expected = <<-EOS
      0  B #{testpath}/empty.txt
      2  B #{testpath}/file.txt
      2  B total
    EOS

    assert_equal expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end
