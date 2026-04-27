class Dyff < Formula
  desc "Diff tool for YAML files, and sometimes JSON"
  homepage "https://github.com/homeport/dyff"
  url "https://github.com/homeport/dyff/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "3edeb78b3166fc7ba4cdea1c9339eacbd57d768f27a77564adf58dc8819df75f"
  license "MIT"
  head "https://github.com/homeport/dyff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1da8f72c9d8bde308ad42399677949015c4e98b3aa5bff777ec120c1dd902974"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1da8f72c9d8bde308ad42399677949015c4e98b3aa5bff777ec120c1dd902974"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1da8f72c9d8bde308ad42399677949015c4e98b3aa5bff777ec120c1dd902974"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fe6041d6fb91a7f4006cb9b43697580db1620c75bb34d4035a6f49daee610bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fcf75f06d0b8faa6135bf9a00746193466cd33d7d181e4a25f6dd6fd0decee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "952916e1820f70aae3a431bdfd2cc072822b9b488e9bc2ce1bcbda11471b9937"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/homeport/dyff/internal/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dyff"

    generate_completions_from_executable(bin/"dyff", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dyff version")

    (testpath/"file1.yaml").write <<~YAML
      name: Alice
      age: 30
    YAML

    (testpath/"file2.yaml").write <<~YAML
      name: Alice
      age: 31
    YAML

    output = shell_output("#{bin}/dyff between file1.yaml file2.yaml")
    assert_match <<~EOS, output
      age
        ± value change
          - 30
          + 31
    EOS
  end
end
