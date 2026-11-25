class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.28.10.tar.gz"
  sha256 "d1f80279c468ba6702e621a2fbf94ee05b3b47d06f99687ea88d3fe3c5b895f9"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    manifest_sha256 "89038a3c346ebc0f7ead91e041814aed5cbc0db1bd3a0120ec03b8ef96e4ef83"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "de8e786a6b1dfa3c9eb4e07602eeff101e604818c7bb6427804fc24b2334a54f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "de8e786a6b1dfa3c9eb4e07602eeff101e604818c7bb6427804fc24b2334a54f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "de8e786a6b1dfa3c9eb4e07602eeff101e604818c7bb6427804fc24b2334a54f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5fe9203a48607e0c08b1658e41ccb5afe1bef802186bea75d783211b8b57370b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "306e50bfcd466df87f6faa4ce9973f3972f1f2e26280eb80aa6e0d8d987232d2"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
