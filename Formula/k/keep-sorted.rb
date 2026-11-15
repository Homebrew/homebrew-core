class KeepSorted < Formula
  desc "Language-agnostic formatter that sorts selected lines"
  homepage "https://github.com/google/keep-sorted"
  url "https://github.com/google/keep-sorted.git",
      tag:      "v0.11.0",
      revision: "167f8ca836e2a3639087849ce0a2f702f8835f88"
  license "Apache-2.0"
  head "https://github.com/google/keep-sorted.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "74173f4fc321615861f1ec1afee35f8c60b7a1f4b295f1edc16e04eb83985338"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "74173f4fc321615861f1ec1afee35f8c60b7a1f4b295f1edc16e04eb83985338"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "74173f4fc321615861f1ec1afee35f8c60b7a1f4b295f1edc16e04eb83985338"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "813f4c463d096c0fb262746f5f830accbd237aa11cc5dc8c9d828c247c07c292"
    sha256 cellar: :any,                 x86_64_linux:      "7f59369303a7dc99e763cad6aeb9fb68a20693b2be347c63c9049ac064559067"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/keep-sorted --version")
    test_file = testpath + "test_input"
    test_file.write <<~EOS
      line will not be touched.
      # keep-sorted start
      line 3
      line 1
      line 2
      # keep-sorted end
      line will also not be touched.
    EOS
    expected = <<~EOS
      line will not be touched.
      # keep-sorted start
      line 1
      line 2
      line 3
      # keep-sorted end
      line will also not be touched.
    EOS

    system bin/"keep-sorted", test_file
    assert_equal expected, test_file.read
  end
end
