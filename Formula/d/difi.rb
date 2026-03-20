class Difi < Formula
  desc "Pixel-perfect terminal diff viewer"
  homepage "https://github.com/oug-t/difi"
  url "https://github.com/oug-t/difi/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "b729eeeb9ede7a1b3b645697a4a51786be25ade436c3143cc2bfd4b874cab761"
  license "MIT"
  head "https://github.com/oug-t/difi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbddf124951df2b6b49f27fc584829ab2b3793e6369a0bd1394d3e48b4bffd89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbddf124951df2b6b49f27fc584829ab2b3793e6369a0bd1394d3e48b4bffd89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbddf124951df2b6b49f27fc584829ab2b3793e6369a0bd1394d3e48b4bffd89"
    sha256 cellar: :any_skip_relocation, sonoma:        "2261af78a5d81386dcd79ff7b3e3af9b2bf37d38a3c6702ae53429d3cef435a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a65d0baf75bc80442b2f0343dec2f7682f4d637e0d24df2f60887855d0d26fef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "490fc7ea18e491fa6af66d9a02b9d1f4521591ca3eb03a4bb19079ef7432c36e"
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
