class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://github.com/kovetskiy/mark"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v15.0.0.tar.gz"
  sha256 "b1b0e65f599c4af7f4d751e1ce494ba4e3c2d7cdaa0ff67eeed1d95b775493f4"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "248563380bc62932e47c4818a09cbaf038a52c36ddbe568a2b5abb752bb1bd4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "248563380bc62932e47c4818a09cbaf038a52c36ddbe568a2b5abb752bb1bd4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "248563380bc62932e47c4818a09cbaf038a52c36ddbe568a2b5abb752bb1bd4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "de0b17fea47dd1ee981263b16baa2eb030e8d8b559b5e7a62e0de6719ddad301"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9690dfadc6ed1c8425d2861c9bab6dfd67d00a18dfa1a91f55cf3b6189189653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "093f6e5a2750052c4cb005f773f4e6b91ffddad3622e4d4f8bfb71283b74919d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    output = shell_output("#{bin}/mark --config nonexistent.yaml sync 2>&1", 1)
    assert_match "FATAL confluence password should be specified", output
  end
end
