class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.102.0.tar.gz"
  sha256 "959154802505ffc25a43fa154066d8952c2e9d32ff54581b29a3327426debfc4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cefdca262c65b07197153317e919b7a7e9ff2bc1689546d1e3b23afaecb084b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eca6c8cd772ac29035b52e70c8ded3e69e4347608d56be4030d81d029c399d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14d8386979a245d63b43209459107b1a477dad331d918df98fc3bcc896f0945d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f3e6734c62dc722c7990cbaa0ae50ae30698ef6ca0c954b82a862b74daca1ab"
    sha256 cellar: :any,                 arm64_linux:   "fad8984418669898f846dc23985251370537389c6bcafcf3dd66a358118b0d1b"
    sha256 cellar: :any,                 x86_64_linux:  "d270833888ef66a57b1f1093f49e511a586ff5ff89f0346e5ae9fa04349ba551"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    args = std_cargo_args
    args << "--features=system-alloc" if OS.mac?
    system "cargo", "install", *args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
