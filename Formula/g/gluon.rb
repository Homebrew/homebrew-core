class Gluon < Formula
  desc "Static, type inferred and embeddable language written in Rust"
  homepage "https://gluon-lang.org"
  license "MIT"
  head "https://github.com/gluon-lang/gluon.git", branch: "master"

  stable do
    url "https://github.com/gluon-lang/gluon/archive/refs/tags/v0.18.2.tar.gz"
    sha256 "b5f82fecdf56b8b25ed516a023d31bcaf576b2bb3b2aee3e53d6f50ea8f281a3"

    # Backport fix for newer Rust
    patch do
      url "https://github.com/gluon-lang/gluon/commit/6085b002e67fb473ab69fbd210433b0e8f7e7750.patch?full_index=1"
      sha256 "5d3bb7f8ff8c2d9be6aaea9f5e4542804b2aa250100993c33ec2daee220a8d07"
    end
  end

  # There's a lot of false tags here.
  # Those prefixed with 'v' seem to be ok.
  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b1212c4a5fa52f91c7e9628c7785059ba3773b1922c140f7e4b6803dfeaa2df2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6925c9400e10685bf8186fccf7cb1cde871e3c5c7e4d8a6d6c19b4fc110f1d7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4f5001264f56d18739d145b9e9423a5e3bfd2e31cbed0649f082516e4f5687d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4393342b66ede5869953b964c303cba89caace2051937c99c114d9c21d980ead"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aefe7045d9ef7fa7830a90e2e794c0f68926bae742f402764d442cd360ddaae5"
    sha256 cellar: :any_skip_relocation, sonoma:         "27627946ae35b4b9e35631903c1cbcb9bcd857375f2d035e3dfa400ab9f77ee9"
    sha256 cellar: :any_skip_relocation, ventura:        "03b4837e4adabb86f4e12acf9310b7888560c97608473b27c230fcd57f1ed88f"
    sha256 cellar: :any_skip_relocation, monterey:       "64fb0c4cda091c3e4ef737ba21f06c9e43bcac513af09f6057b077f11c86e793"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4c82fdd95ab9c907ca146f9cc9f5f8c34d026389368d81bc5943fee7d6b28a5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba2ee59f07103937ec724410329016ff048f6da389b45b78fca28a63f11c18d1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "repl")
  end

  test do
    (testpath/"test.glu").write <<~EOS
      let io = import! std.io
      io.print "Hello world!\\n"
    EOS
    assert_equal "Hello world!\n", shell_output("#{bin}/gluon test.glu")
  end
end
