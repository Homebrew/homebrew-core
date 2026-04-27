class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.97.0.tar.gz"
  sha256 "c2f1cd14b8c398044c40a1f199006288aac77946bbb284f627a494e96c3fa0d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90823e569af16c073c2d1a86d9bc147da910238cc69c6daf39d66e52d2f5fdc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b8d63ff566a0f48b6226f114f090eb82b0d1d67c7253ebec16760825f307d5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b27819f63f830a45d7788a463eabedcb1a4a5d5109c3b79092f0ed59b740957"
    sha256 cellar: :any_skip_relocation, sonoma:        "75d342b7d8faf275adda2b373da2c5927872e24845e6cf65405b064ee00abea5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a967c3c614ecfd8282afedfb9bdd8c0c6a579b27761bb73d95c573c9dd40804c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b152ff98d9ac6332c5dfdc07dfa4c4a6ca9db7de7481327a624db95479c0264a"
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
