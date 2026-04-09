class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.59.0.tar.gz"
  sha256 "19678e24a271e7f7a9596f64dcc8286abc715b0bdbe0df478963dbab8c49f0d8"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53b8e5aae4400e3cf78687fe416c6fa66f76b29d61b43dc0e95cb889ecdac849"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53b8e5aae4400e3cf78687fe416c6fa66f76b29d61b43dc0e95cb889ecdac849"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53b8e5aae4400e3cf78687fe416c6fa66f76b29d61b43dc0e95cb889ecdac849"
    sha256 cellar: :any_skip_relocation, sonoma:        "97d6a16d6f6d7610bd665c4af3f2a70bb50d18faaf6c4a2616d65f1cdc07e81a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de68c82a31d764c05d2c50758d2d90aa16b507abf0801a99a883e5b137b7fff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "102f7ab8c6c866eecf72c74531414d32082b86852faf0ca13cf5f90751359c90"
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
