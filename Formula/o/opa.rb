class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "bd557bfd0aec3919788937b70268e1421a451c74333efbd0175d08d49ec039a0"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9a37db0563b26b7ef609d7352d4a8ef787486d152d1eda65ab375ff96c36a2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f8b2d19a0016091e034314a577066041218b49273c0240987782a7c26a6cad0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf3f61e6436602ad8806dd7b9934eff289a547b85274483ac35623c26af1505f"
    sha256 cellar: :any_skip_relocation, sonoma:        "44a37040c8414e4730c09ce92aa4ecb67d83b759fe4e56fbaba176138c4546da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9bc098f8c71807e32845d1f66f0d46b16739f5627d3cd7278433578be312bdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f41991429b9226ee14bb6ff01a25b70999e476033ce2c56efb5e07ff114c0529"
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

    generate_completions_from_executable(bin/"opa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
