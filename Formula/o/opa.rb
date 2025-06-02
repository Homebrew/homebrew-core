class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "e1745bc2dbf73d5e17f9360f7f9224e74555a9b907af7fca2c28e4dbfeb9e1be"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "305f7ce5b2947ffa6a97e810249cdd9bf483a791b234d484e9b0728d5d481aad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0895d4bdd3b0c3630bde9ddce7c5aa3bcecfe4cedc4600da037581b899a02a2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3030092ad6973215c3307cbc19372185a1ad54206b368f5be0cdc12afe2e337"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b3150311f80ffbcffe511c6caab7831b81cad06a9a4471ccb243397676034ba"
    sha256 cellar: :any_skip_relocation, ventura:       "028ebe629df0270b4b96e314f20d5a21417db6bd6c21cd67cbb8f85d3e3f2aaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa5ce0d669e0910bb70ae65d703a6d5bb7b44cc3c0ccf7c9cb9c9ef20f21e381"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
