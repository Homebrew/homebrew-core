class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "1582958d1b03d7bc7c44812e49e4cce606f6509fd7bf9950d05f1c95425ccd11"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b86dc21fb88e7bc40f01cec30da77edeeb165b0abf3c2aa0640fb8bda0b5dd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a869ce6b94ed9526935d36b76a9ede30e15fd123d18e9ae47e53f89ae32045f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94d217e05a5547336e7fbaaf90b3bb02f9bfe46efd77e301421af81fa9326877"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a06be1114e450ce534cbdec2c70a7a38b657b440f57bada238dd201be9667fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca0f133663e7fd14861cbcbdb66d962ed3e24bb6c143cfaffb95ab781ae864fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10fe095971edb7c7172f2a37bc1238c0490a59def8a4210fdb849a5e563e307a"
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
