class Difi < Formula
  desc "Pixel-perfect terminal diff viewer"
  homepage "https://github.com/xguot/difi"
  url "https://github.com/xguot/difi/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "3d5955f1ed2d8cf9162719b3399dd4b7ae2a888322484ee921ea0add3f0f94d7"
  license "MIT"
  head "https://github.com/xguot/difi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14b6ad2d5bbf4f7ff24b6b6013039c92de37c65bef9b08302891cca1371099fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14b6ad2d5bbf4f7ff24b6b6013039c92de37c65bef9b08302891cca1371099fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14b6ad2d5bbf4f7ff24b6b6013039c92de37c65bef9b08302891cca1371099fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "2855461001ea3eb20a4aa8571ec95f7e651ba1cc33c2891e2dfe9bbcc786b176"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "160665a8f264c0a8902e71d1661d6266eb00a8a2383760fbbdd2092eb5dff2aa"
    sha256 cellar: :any,                 x86_64_linux:  "aed318afacd32ef49be4e1dee95732473e9b5907b7718675aae4d48fae27b4ad"
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
