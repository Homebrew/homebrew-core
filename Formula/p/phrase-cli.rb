class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.35.5.tar.gz"
  sha256 "0a421d0cc57b45b40653d406ea787f1564240a58d454f1b28a0292da6e6cbdd8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0ecbe706010de639a99f94c5f3f77f626ce95fd16344f3e59d92f7039d9252f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0ecbe706010de639a99f94c5f3f77f626ce95fd16344f3e59d92f7039d9252f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0ecbe706010de639a99f94c5f3f77f626ce95fd16344f3e59d92f7039d9252f"
    sha256 cellar: :any_skip_relocation, sonoma:        "510a9d32b82f1af9acd468cd0e3c942b809b6c4a7563789e2d01a3e7c522cd12"
    sha256 cellar: :any_skip_relocation, ventura:       "510a9d32b82f1af9acd468cd0e3c942b809b6c4a7563789e2d01a3e7c522cd12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6f8f328a0ec924019f5c1011ee49ea85c563022d3656b247514c230a499ef3a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
