class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https://noborus.github.io/ov/"
  url "https://github.com/noborus/ov/archive/refs/tags/v0.50.1-pre2.tar.gz"
  sha256 "57705ccc17f859baca43ef44871e710070928fef62f9612ebd7431f37afa8c07"
  license "MIT"
  head "https://github.com/noborus/ov.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a680c356f64f025522345ce4217414ae21ae612984f6ca6b156ea237cef77a8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a680c356f64f025522345ce4217414ae21ae612984f6ca6b156ea237cef77a8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a680c356f64f025522345ce4217414ae21ae612984f6ca6b156ea237cef77a8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4faa5cac98a489609404759996f5b791bb6de286ff427afc88c4e4cb2f9fa8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dcf17a4f7902544117f0a55b98e93e3f07dbd459e02d9ac5c0140ac4cb8042e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1caf8adf03b62bd7e4ee7e5045221a4c81cef9f3b8221f70b5ae0030a786a0f2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ov", "--completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ov --version")

    (testpath/"test.txt").write("Hello, world!")
    assert_match "Hello, world!", shell_output("#{bin}/ov test.txt")
  end
end
