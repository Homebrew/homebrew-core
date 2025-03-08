class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.4.1",
      revision: "80b27cba258b45aee4cebc5eac86569d2ae47857"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b3a51c48f413203bbf56d9c92d25b6d76c23296d13f779e47b28324e695dbf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b3a51c48f413203bbf56d9c92d25b6d76c23296d13f779e47b28324e695dbf0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b3a51c48f413203bbf56d9c92d25b6d76c23296d13f779e47b28324e695dbf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b383b4eb88426a3e43bc820c70955756dea7b0b2327a4c2905f698ac496715d6"
    sha256 cellar: :any_skip_relocation, ventura:       "b383b4eb88426a3e43bc820c70955756dea7b0b2327a4c2905f698ac496715d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7e4222d622a79da4bfe2cad2367c99b26d1fedbbb69dc3df2b85fe29e2a7c61"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/Azure/azqr/cmd/azqr.version=#{version}"), "./cmd"

    generate_completions_from_executable(bin/"azqr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end
