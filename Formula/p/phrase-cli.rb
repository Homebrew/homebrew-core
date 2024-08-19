class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.31.2.tar.gz"
  sha256 "4af5b8b3a16fe4c567499adb72f8b3fb8b1a6b7f13be311cb715ad858e06f2db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19ee30fb427b144b079836de5e6b26be253d058bd20f1094bca273806283912c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1191334ab8e64dd90d0b62fcb395962eac67b669269763fee2bfd8403646afb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "465a4cdd13bad88628ff9e671871ef4385ef5dd76afe374268724d17561abac7"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e79d462d97d8dbee495851aefa416eda49705f7c0994046dc1da26d74589038"
    sha256 cellar: :any_skip_relocation, ventura:        "6f185f7e92b5f838d57022b87fd1a4c48775e7a626f1f1aa27288ca1d4555d55"
    sha256 cellar: :any_skip_relocation, monterey:       "e41893ee94d01c7178172b2fde6883fbaeed294d6058726b586abb0c7cf23dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8ae3ca45ff801caefb058e3f26c8f94e51ac37246c6a2573956e9a4043db6bf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
