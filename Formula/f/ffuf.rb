class Ffuf < Formula
  desc "Fast web fuzzer written in Go"
  homepage "https://github.com/ffuf/ffuf"
  url "https://github.com/ffuf/ffuf/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "80b42fe3dda8b24e10bade7b18651d402d1acf5031baedd0b344985721f3d8cd"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "601850e466df5546f7c6cba056de0a5e80eaf91000a0a5573de8591fd32f16fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be6328a00529ade232dedc91d8e2377cf5d7c8685420b829a9a72378a141f488"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d62fce87044bf41948e62ef5f21cbaa4b3cd24f655f672bf977f29d5ce0402b"
    sha256 cellar: :any_skip_relocation, ventura:        "298e7024508bd2af91a1a17df404ae57a5c0e3c7034b89ad4c56c724294e0a46"
    sha256 cellar: :any_skip_relocation, monterey:       "aea5ac12792b30b7c2a6d65c5ad18a802cd99f06ce1e285d182ac67fff5c4e07"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5d6cdb72ffc86050d943b27165eab08f863788d53222f237fcd74554ed935ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e00bda411a7c3edfb125ed585487a8f141de2ccb844d708c4bef0210870726d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/ffuf -u https://example.org/FUZZ -w words.txt 2>&1")
    assert_match %r{:: Progress: \[5/5\].*Errors: 0 ::$}, output
  end
end
