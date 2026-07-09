class Difi < Formula
  desc "Pixel-perfect terminal diff viewer"
  homepage "https://github.com/xguot/difi"
  url "https://github.com/xguot/difi/archive/refs/tags/v0.2.30.tar.gz"
  sha256 "55f5d17a7ff51dafe6fdb8ece6d9d663582da51b712e9d73efedd78208ba9e5b"
  license "MIT"
  head "https://github.com/xguot/difi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3a5068598ff16cf5dee5809b1a1fa172d163fc3b247b288d2375fa8d96b0356"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3a5068598ff16cf5dee5809b1a1fa172d163fc3b247b288d2375fa8d96b0356"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3a5068598ff16cf5dee5809b1a1fa172d163fc3b247b288d2375fa8d96b0356"
    sha256 cellar: :any_skip_relocation, sonoma:        "97ae577103d1654433f885b527fedb8dca0cf1777c4de43070678c3e2089ef1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24464aa1c1b8a21a3167537126beb7fa9db01dfc55347267aa50a18929614cf8"
    sha256 cellar: :any,                 x86_64_linux:  "6c82bc293c700a9a4bb765712ab903e339cab9b09fd1add91558f636d8b5c41c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/difi"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/difi -version")

    system "git", "init"
    system "git", "config", "user.email", "test@example.com"
    system "git", "config", "user.name", "Test"

    (testpath/"file.txt").write("one")
    system "git", "add", "file.txt"
    system "git", "commit", "-m", "init"

    File.write(testpath/"file.txt", "two")
    system "git", "commit", "-am", "change"

    output = shell_output("#{bin}/difi --plain HEAD~1")
    assert_match "file.txt", output
  end
end
