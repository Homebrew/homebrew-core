class Difi < Formula
  desc "Pixel-perfect terminal diff viewer"
  homepage "https://github.com/oug-t/difi"
  url "https://github.com/oug-t/difi/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "166ffd7e30d14eecdbbef99f9bada441b6d397af2abd78089cef125961517398"
  license "MIT"
  head "https://github.com/oug-t/difi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca45e4d005e391867b7be44e328ec9d8cbafb77b6fe45a466cb0ad786f606b67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca45e4d005e391867b7be44e328ec9d8cbafb77b6fe45a466cb0ad786f606b67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca45e4d005e391867b7be44e328ec9d8cbafb77b6fe45a466cb0ad786f606b67"
    sha256 cellar: :any_skip_relocation, sonoma:        "31bd90f2447d50b9fbe8fff32f5c70d2296f8a9e1b4e345e9cab0751ca200b63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17e4c0ce23a3abfd555f49c443d8edbea15d0f6e9ea517dc10e016ec0c1e5a37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2402bbe7c108fe5ef10242b71cbe18e9ad84425469df65db0260d9f9f1b4df5b"
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
