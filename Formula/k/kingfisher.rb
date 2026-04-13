class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.95.0.tar.gz"
  sha256 "15823fe7b41cfaf78eb90b4ce93da6c554da73175f3e82efa86f5970f614acd3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7285c936c4275b98877bd5cc101c8a73a2dd387491cc4afa239adb362bfcc597"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c864d9d107a48c45bd3d6e0daaad0539d1a86ea50b2fd00ffbd71b1b02572963"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47cccf295a6d5addcedeaa8712924d5d555ae233da7acd35c3680f540eb9451a"
    sha256 cellar: :any_skip_relocation, sonoma:        "35f751381a0d9d3aa9a7d1eb2fff62ff54acfee769defe0e6b71907ea6d082d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0dbc1f096015aaa8892990c56d54ef1cb48fd847af1e40b7ec7b26b84329118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f6d64d06569570c6de669b6cbe03d484a34810c670829c105e0e1030897aef5"
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
