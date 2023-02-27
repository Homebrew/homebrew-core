class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.6.8.tar.gz"
  sha256 "a6c6e2112e0f20e5f6d1bafde37f11cc5167a77d187ae247922b4ce69df2a3ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84c7257d24387d7faa43047b8b0a12c3ec330cdccff4b9aa05bebc533c737164"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ccf119132f5ed356be68fb38570b75ad68e94ad302e50242cc3235bee6e146f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7fbfedf340137001e3372d12520f30a85ef84671524b66b3347ce9a06d70a90"
    sha256 cellar: :any_skip_relocation, ventura:        "9e6587cceca37967d2777f051a6800aef0e3a0319f0b9b71d2f0ee66755843bc"
    sha256 cellar: :any_skip_relocation, monterey:       "e38f0a7d16e0f4502b721acfc42613919c81e2395a7d1a1933417c8190d157c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf09d2c132d279c4dd1d8004c96615139544403f99309272b889cdcdec4dd378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25d27be3ce9999ecb522b9a42c3716cd22d8177c18ee89c8213ba9ec52027972"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X=github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
