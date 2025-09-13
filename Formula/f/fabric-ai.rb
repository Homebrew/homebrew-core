class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.311.tar.gz"
  sha256 "8ea167d7176c8a43205355e7e911d5871f889bcd678c561e94c39b53ce684ae4"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f14d42564f370530ec2fe241097321190a49dbfdf02876462e3eeee97c307674"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f14d42564f370530ec2fe241097321190a49dbfdf02876462e3eeee97c307674"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f14d42564f370530ec2fe241097321190a49dbfdf02876462e3eeee97c307674"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f14d42564f370530ec2fe241097321190a49dbfdf02876462e3eeee97c307674"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7bbe4230c66265778dafb5b02d9bbbfe6061412ca58e5be8e13fd489725015d"
    sha256 cellar: :any_skip_relocation, ventura:       "a7bbe4230c66265778dafb5b02d9bbbfe6061412ca58e5be8e13fd489725015d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a044a94786ad9fa4ae7b0b291dc2e554601d49655f0134eee7366a862dedcb96"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end
