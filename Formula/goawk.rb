class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "997225c30c544eeccb31487d69f34e736d8027269d74b1173e82dd62a545b8d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67bbc974741aa0362d1174d48b33ef2aae9476112c7defbbedab62fe6bd9d5d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67bbc974741aa0362d1174d48b33ef2aae9476112c7defbbedab62fe6bd9d5d1"
    sha256 cellar: :any_skip_relocation, monterey:       "897c731de7a931d22e57d3cf27fb6b5514f9a028c2c658217b6710119cfe7b1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "897c731de7a931d22e57d3cf27fb6b5514f9a028c2c658217b6710119cfe7b1e"
    sha256 cellar: :any_skip_relocation, catalina:       "897c731de7a931d22e57d3cf27fb6b5514f9a028c2c658217b6710119cfe7b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa879fda9cbdd1d908c8a75170654a925c8f8003f7627e92f24ec0d9f12a106b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
