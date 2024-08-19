class Alexjs < Formula
  desc "Catch insensitive, inconsiderate writing"
  homepage "https://alexjs.com"
  url "https://github.com/get-alex/alex/archive/refs/tags/11.0.1.tar.gz"
  sha256 "0c41d5d72c0101996aecb88ae2f423d6ac7a2fc57f93384d1a193d2ce67c4ffb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9fedd4f4163590c33370cbcbd31ba440198da82093e66414f6cec2393a9c75cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63048df11763713024140ff157290f205111355b18f685c935bf74172e7ff8b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63048df11763713024140ff157290f205111355b18f685c935bf74172e7ff8b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63048df11763713024140ff157290f205111355b18f685c935bf74172e7ff8b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4c0fd4ad781052b61dbd91767d15d9ce760d0371378dabe9f4e9415b6ad181a"
    sha256 cellar: :any_skip_relocation, ventura:        "5932fb08167ee8a713de4e5f523083a622a24c2f68e75d74ace3c07cfa79ca28"
    sha256 cellar: :any_skip_relocation, monterey:       "5932fb08167ee8a713de4e5f523083a622a24c2f68e75d74ace3c07cfa79ca28"
    sha256 cellar: :any_skip_relocation, big_sur:        "5932fb08167ee8a713de4e5f523083a622a24c2f68e75d74ace3c07cfa79ca28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63048df11763713024140ff157290f205111355b18f685c935bf74172e7ff8b6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.txt").write "garbageman"
    assert_match "garbage collector", shell_output("#{bin}/alex test.txt 2>&1", 1)
  end
end
