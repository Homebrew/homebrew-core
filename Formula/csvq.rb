class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.17.8.tar.gz"
  sha256 "2e5c189d62f2dfd4f7a593be640893925626e49ea44ad020c1b141d82849e128"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1171a5b2986629b729ae85950c207729796b1c049d8bb8858966b4904868afd6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bb7a9c5e60e0e438c8024b6edc72913506acd211db4d84ac9c8c4ad7ce1ee52"
    sha256 cellar: :any_skip_relocation, monterey:       "c17404008324ba87a2c50cffac1b45f56d2cb375474100a46a16ffbe1f352381"
    sha256 cellar: :any_skip_relocation, big_sur:        "246a3106a23d522ac865006e20ef6f8637df3cb0e56b29652234a20363604c1e"
    sha256 cellar: :any_skip_relocation, catalina:       "12408b2d452c6f883e886d11a9cd02b5d28a45528de4d61d69ed8bc41fae1d68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d9642c155ac3dfb703721c784cf50b9e2584295c3a55ea3b032d4a380e48288"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/csvq", "--version"

    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
    EOS
    expected = <<~EOS
      a,b
      1,2
    EOS
    result = shell_output("#{bin}/csvq --format csv 'SELECT a, b FROM `test.csv`'")
    assert_equal expected, result
  end
end
