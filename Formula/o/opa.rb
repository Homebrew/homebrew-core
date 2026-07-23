class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "4bec39f66682a370cac357c76303e4517cb35e236c04a221e315350550280c50"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cf833a971d460312e760d80c72758b50de50164162872e33305460c9d7708a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "637e11968562d99e722d3598169dfd77cafd61878e7705d615f896e89faaac87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac935bc125bbb5a65ff21682175a30eb672eb0bbb848a450f19b220a1ae1b83b"
    sha256 cellar: :any_skip_relocation, sonoma:        "80bc1d872fd38de1b1441320cea769a2ffa4a436a376d480ccf11cb3778ba18a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f355acd818003afd75316040d28c151d37057a385db2d9591d8eea903f63fcc"
    sha256 cellar: :any,                 x86_64_linux:  "72ee21bfd09c70559be6a88808d5e140465a2112a4b9da06a2e04e5cb2a3ac52"
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
