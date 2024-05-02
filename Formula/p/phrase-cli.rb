class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.27.0.tar.gz"
  sha256 "512733207f1ee1cb5adc8b325cdd7a6a64e4111594e23d03d65cdaaeb5487f0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4def6e403d1de8494858779b534c0dd09befe19f4d896bbc1436009883b13e20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "743136db56db1049e0ebd002dabb96a80555cb9988c9171ffe21dd3e5634f79d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e2492e9630502b35d05c16d2ab2df3255e2cb4bb0e0bd80de0ab1b81392686d"
    sha256 cellar: :any_skip_relocation, sonoma:         "48e7fa0c94fc6cddeb29c0f44def6108ad5606d310a24bd897128eb8362f0345"
    sha256 cellar: :any_skip_relocation, ventura:        "6f952e52a89521fdb09f91b47f77c9bdb3de7f26f4bf505fdbaa29c0e6d6d7e1"
    sha256 cellar: :any_skip_relocation, monterey:       "8488c8cc1eb4f0b2348a905795a692dd911fac697fa8bbf36ce66ea0e6247cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ad9574660305afb0f25d2eb7c1beaf1ad4df9aa595efd368f47a7c07fad79bc"
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
