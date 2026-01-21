class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.54.3.tar.gz"
  sha256 "f5480779c2e051932f6c83189d427bb96776e93282a06de75a8a09170328a63a"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "185a86224881a7d6e88d643a1ca421ef270b7a71ebf8fa07adb8d6b2927c0e29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "185a86224881a7d6e88d643a1ca421ef270b7a71ebf8fa07adb8d6b2927c0e29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "185a86224881a7d6e88d643a1ca421ef270b7a71ebf8fa07adb8d6b2927c0e29"
    sha256 cellar: :any_skip_relocation, sonoma:        "749bc517e625f4d4ed7e20cd7d96f4f35fcf200406f55c8643b7cbdf6af64d35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4a8091b0926fdd9e9c7c0c19d5b1ab9762491d69bb46cd96b3dfa987ec781ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2ee04c8d0b86e206c503e5bb8284240d0e716761342fd8fc6e259df890235ff"
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
