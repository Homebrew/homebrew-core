class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.19.1.tar.gz"
  sha256 "f07adde85b24bd99538fae89a3feaa7c869cb1282534771552bf2edf53695859"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe982cc1cfd65a9236e6a519f671b730d7f304b1744f58b46cfc7ab17b8b24d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04a29a17a04f70c5946da05c804026092ca3928a826e531bacc62eab8a29fb55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85b8e63fa6663eff809bdb63920242876c4dd29fa56f887b3f8633b41106a1ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "235fa9e9db18d2854ef175ea3baac7675c00780d6437a2a7b25262c5d99635f8"
    sha256 cellar: :any_skip_relocation, ventura:        "368bd918b55df91c7e04d34d80afd70bcbcb3bcefb44143d61e7f3bad6bf9e81"
    sha256 cellar: :any_skip_relocation, monterey:       "5ba2866ad38b63a1d274f40447bf571f7f6e2b4c92213460183cf1071ded82fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "141a4a395c2bce9c0e20237447501187b20c633b5b9d31ee57eeb3011d19ca97"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
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
