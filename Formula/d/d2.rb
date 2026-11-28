class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/d2lang/d2/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "a1978c3cc6c334ef09756f2d5eceb931402cf0a2a7335eaa96386e8d6c4695b7"
  license "MPL-2.0"
  head "https://github.com/d2lang/d2.git", branch: "master"

  bottle do
    manifest_sha256 "e192338ff6ffa284ab2ebf66de5e89ad6898c08cd0b2b011d883d694cba68353"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b7e87107735c3047e7e659b1df48cf664179b1ffb718fe12ba539ab488dd93f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7b7e87107735c3047e7e659b1df48cf664179b1ffb718fe12ba539ab488dd93f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7b7e87107735c3047e7e659b1df48cf664179b1ffb718fe12ba539ab488dd93f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "14b4dd3217115ac968067ebaded3dc02929fe882d02330e995f063129c84e8fb"
    sha256 cellar: :any,                 x86_64_linux:      "30b45724f4ee23fef9cf185242b1d5af2ff7d8b35ad7a51123bdc5aa55132297"
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
