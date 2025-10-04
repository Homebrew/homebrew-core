class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https://noborus.github.io/ov/"
  url "https://github.com/noborus/ov/archive/refs/tags/v0.43.1.tar.gz"
  sha256 "57ecbfff919cf59db59cd1aa1b251ae3de34857a15176de6cac23ce75518d844"
  license "MIT"
  head "https://github.com/noborus/ov.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dca15297eab936d53bb26dc722ff76affbb221ae7d504658008f4f78acd6c3a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dca15297eab936d53bb26dc722ff76affbb221ae7d504658008f4f78acd6c3a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dca15297eab936d53bb26dc722ff76affbb221ae7d504658008f4f78acd6c3a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "aeaa405442efbde6b7fee891e49b3c16b7aa1b1c0fc3c7545e4252621a35dc4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb75e838d48ba686d0f482d24af277b945006e0424a49930144a1838555c5e66"
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
