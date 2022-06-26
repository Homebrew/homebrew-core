class Age < Formula
  desc "Simple, modern, secure file encryption"
  homepage "https://filippo.io/age"
  url "https://github.com/FiloSottile/age/archive/v1.0.0.tar.gz"
  sha256 "8d27684f62f9dc74014035e31619e2e07f8b56257b1075560456cbf05ddbcfce"
  license "BSD-3-Clause"
  head "https://github.com/FiloSottile/age.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57281390b7c051f73ed13e7e35413e42eb9bd918812bc99de38ef3817ac46dee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "845a84de1a024a350ceacdfcf11745df8100df2377b18efa3ad354528127c72c"
    sha256 cellar: :any_skip_relocation, monterey:       "43d2bd6b8768a9f0dc0b9da36c15ae1f01640002044a16444acdc7a5100438bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0e0fc5e332fe33bd31d031ffe0a9b58cdd4f4d6f8091c6746e80adaf68ffd58"
    sha256 cellar: :any_skip_relocation, catalina:       "309d3c08abe1e8559c8cb53cbf178c52d4286a50c85ad8e1a5b6b400f0fdd296"
    sha256 cellar: :any_skip_relocation, mojave:         "ae8a1716f79382d7367d87c28d5b9c77a13d2c85c0680b955378eecd0c446783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b220f76c4b553973ef0050716aa7bc248ca92517481c5c811d190dada2dc40e6"
  end

  depends_on "go" => :build

  def install
    bin.mkpath
    system "go", "build", *std_go_args(ldflags: "-X main.Version=v#{version}"), "-o", bin, "filippo.io/age/cmd/..."
    man1.install "doc/age.1"
    man1.install "doc/age-keygen.1"
  end

  test do
    system bin/"age-keygen", "-o", "key.txt"
    pipe_output("#{bin}/age -e -i key.txt -o test.age", "test")
    assert_equal "test", shell_output("#{bin}/age -d -i key.txt test.age")
  end
end
