class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/d2lang/d2/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "1256ad3907bceb4fcee7ed40d17c5726f8b602eea900e94500ba3352e96febbc"
  license "MPL-2.0"
  head "https://github.com/d2lang/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fff1255d00f1dbd66353d680b440f697677dfb68c54a93fea271118fec73c83f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fff1255d00f1dbd66353d680b440f697677dfb68c54a93fea271118fec73c83f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fff1255d00f1dbd66353d680b440f697677dfb68c54a93fea271118fec73c83f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "fff1255d00f1dbd66353d680b440f697677dfb68c54a93fea271118fec73c83f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "29e91a66c47fe0e014a50843b2d09ba767e30e2caf08d51f2f18e40dc2938b99"
    sha256 cellar: :any,                 x86_64_linux:      "f8783a842cb964680aad7dfaa26aba87095ad389d9932b08d68ee1487fc5ea3d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/d2lang/d2/lib/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "ci/release/template/man/d2.1"
  end

  test do
    test_file = testpath/"test.d2"
    test_file.write <<~EOS
      homebrew-core -> brew: depends
    EOS

    system bin/"d2", "test.d2"
    assert_path_exists testpath/"test.svg"

    assert_match "dagre is a directed graph layout algorithm implemented natively in Go by Dagro",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end
