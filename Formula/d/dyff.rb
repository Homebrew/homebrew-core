class Dyff < Formula
  desc "Diff tool for YAML files, and sometimes JSON"
  homepage "https://github.com/homeport/dyff"
  url "https://github.com/homeport/dyff/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "961d9ac91a0d2e8a45fc4f11c6ab5514af3f42e572b066012dab06498da17315"
  license "MIT"
  head "https://github.com/homeport/dyff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1002734c45436a4372fec8f0dc57db44937854fefdebc99e5667ad329a2b6e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1002734c45436a4372fec8f0dc57db44937854fefdebc99e5667ad329a2b6e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1002734c45436a4372fec8f0dc57db44937854fefdebc99e5667ad329a2b6e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "88548b89220dcd1aea63c71cafb7aa67c605b914882028c3cba64d0172966b42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdb3a9e0052be88d2dbb8593f4421c814736b819c6c7292909a337b89a29f465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e3b7a1800ad9d6740f6a164ec3dc062e7dadfcf9d69c8c0e2ca9566288fdd3d"
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
