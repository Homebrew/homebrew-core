class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.55.1.tar.gz"
  sha256 "b01c0aacbba9d2228d41189faa15c25fff80fae4afecb0556c14959c546975b6"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54102d1d34946e9dfe030b167db1633e46968fd9ba825c55ca38d29f530908c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54102d1d34946e9dfe030b167db1633e46968fd9ba825c55ca38d29f530908c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54102d1d34946e9dfe030b167db1633e46968fd9ba825c55ca38d29f530908c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "00313dacc6f84f1aaee74577920d843faa177fc3566cf979d31f2ba731a9998e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38db3873f027bdb75db2019d297d4493a3b2a3c62bc8bcf7e8562292136dddfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e091434aaf4cd3862628d8d9dcf2daa24c90caa9608620bdca4ae3df680312f"
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
