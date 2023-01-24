class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.6.5.tar.gz"
  sha256 "18b612ef36270fc1476fdbd3a1ef43282574fd172568b192121c95e38cdb2e05"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1d134bc7a9d6ca09e69e64fbb4fc9834de8b5b74a9a0687659627d53c0a8388"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51dcb7e6a12fc6054d2bcbcc9023b2fd64bc54481a3a4f09f9d74830f7e4f3fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dada5b212876ce0b53c75c951dacb5dc1fb9520cdf9061d6c29cc61795f80f0f"
    sha256 cellar: :any_skip_relocation, ventura:        "98514337ce52badcf72a9adbfff7fa4394bc933650a7fc962bd7b004bb1081ce"
    sha256 cellar: :any_skip_relocation, monterey:       "7ea87f899a3fb34053b7bc8ad6e3e0b9e78294dcf7ea89f4a83bb70b4766bfa5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a08719a946d057a32ca1fa69deffb5e219efb8513653125a329b96afc5ca7036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49654981234e9c1f015e78b4b76a9001bf7184ee261fb2be065d934f722d78f7"
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
