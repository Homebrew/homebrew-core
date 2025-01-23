class Counterfeiter < Formula
  desc "Tool for generating self-contained, type-safe test doubles in go"
  homepage "https://github.com/maxbrunsfeld/counterfeiter"
  url "https://github.com/maxbrunsfeld/counterfeiter/archive/refs/tags/v6.11.2.tar.gz"
  sha256 "8a8cc2c51d3118ba8fdac1bc93bb1c25fd6fcc135415f34ce3b02fc057be2f2b"
  license "MIT"
  head "https://github.com/maxbrunsfeld/counterfeiter.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5b1ce50092552ea9b705730a0a111a80e0e3cfa6ab38155f20a4bb2159080d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5b1ce50092552ea9b705730a0a111a80e0e3cfa6ab38155f20a4bb2159080d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5b1ce50092552ea9b705730a0a111a80e0e3cfa6ab38155f20a4bb2159080d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bb3461edc31c61bcdd5cf69d3e4973ea98e6d51e3d82d26c22963e1d0128e16"
    sha256 cellar: :any_skip_relocation, ventura:       "1bb3461edc31c61bcdd5cf69d3e4973ea98e6d51e3d82d26c22963e1d0128e16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2459c5b2c06488e4387b4fa51f438e22210fe5c6a4ca8a33a45a015ae0e4ed3"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GOROOT"] = Formula["go"].opt_libexec

    output = shell_output("#{bin}/counterfeiter -p os 2>&1")
    assert_predicate testpath/"osshim", :exist?
    assert_match "Writing `Os` to `osshim/os.go`...", output

    output = shell_output("#{bin}/counterfeiter -generate 2>&1", 1)
    assert_match "no buildable Go source files", output
  end
end
