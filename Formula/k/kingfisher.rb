class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.106.0.tar.gz"
  sha256 "578ddbb2bfc4d135128afcd032aede588c51e93b6dcafde0f3f86235f566a393"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa526c331abc4b83da493deef2cca751b5af0bb4136a6953c7c7ca6673c76496"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a70f384da06643eb17592959627dfb4b1c09bd078be6ecfd50e6787953442a74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16063c8add1ea92d286592f943c8c16ff4507a341ad233476ac9e958f9923b1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "637f008aa27c36eafbcd114a41f2de7569785b44302d1ed3352bd746136308cf"
    sha256 cellar: :any,                 arm64_linux:   "c740fed26c5bad46316af505d3875a0526af96768addd55d12112b8d282cafb1"
    sha256 cellar: :any,                 x86_64_linux:  "7d73f77a2cb6a67217018c83e6e1c496504f8c11df0aed1f79f0cdf33f6bb232"
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
