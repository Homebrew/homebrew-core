class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.65.0.tar.gz"
  sha256 "c9fe35dee01381c8176a4f6255ebfda16776bcd765bf1699ae5da6f71112e8f3"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8426f9c418023964b62162926875a37b592d25b80e79e428b6a5b4e799c8138b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8426f9c418023964b62162926875a37b592d25b80e79e428b6a5b4e799c8138b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8426f9c418023964b62162926875a37b592d25b80e79e428b6a5b4e799c8138b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5635a1c5a9a9cdbc3ff0788c861b9dbf4e1ad87935a7647ef60ab0a2626c7a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "017dcb01de80ceb2d7e61754fd7d98bc135dd60485b8ba6574085206864f0020"
    sha256 cellar: :any,                 x86_64_linux:  "aa46cbca6e8a100d897d48de5bb616b5bee0d376b43bf928144e602bb70e8ecb"
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
