class Lazyjj < Formula
  desc "TUI for Jujutsu/jj"
  homepage "https://github.com/Cretezy/lazyjj"
  url "https://github.com/Cretezy/lazyjj/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "67cb6363e40e97fdbced8a789d93a4fde14ac12a74baf83a600ecc48b8baa0ef"
  license "Apache-2.0"
  head "https://github.com/Cretezy/lazyjj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0212c6dc5663065e4ddd53929fdc6d3810b7b7f762f17cc52e1f02c32231073e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9285414913cafe9776fee472824deffa0b6f03c86fac4e531e62a8c58a10fd9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa4a9daca65ca854f3ca9cbc5505b076a16a61f53ba7145d99036316bbac6de6"
    sha256 cellar: :any_skip_relocation, sonoma:        "78a96d3afef172a336db8e721539341a500d8e373134f1c67ff5afded93a66e1"
    sha256 cellar: :any_skip_relocation, ventura:       "fa1c36a2ae1e1ffb1e341fd27fac8de8aa28898a00d4ed7e8d304803eddf911d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c0a6d3272ad035c14e7c141c8a56b304a4039b63e9294cf5a78f94dd33693fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c3dddf8d87fbefae71b6c798e8848a16ba81fd04c3eeb349b889d200ae65105"
  end

  depends_on "rust" => :build
  depends_on "jj"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["LAZYJJ_LOG"] = "1"

    assert_match version.to_s, shell_output("#{bin}/lazyjj --version")

    output = shell_output("#{bin}/lazyjj 2>&1", 1)
    assert_match "Error: No jj repository found", output
    assert_path_exists testpath/"lazyjj.log"
  end
end
