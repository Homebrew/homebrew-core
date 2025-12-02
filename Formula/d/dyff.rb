class Dyff < Formula
  desc "Diff tool for YAML files, and sometimes JSON"
  homepage "https://github.com/homeport/dyff"
  url "https://github.com/homeport/dyff/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "36e103c1424e79135bb4ed54d6b66e6c3f057ff422a5838d3a80ffd4d9a3ef27"
  license "MIT"
  head "https://github.com/homeport/dyff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "363504d9c330819c74082c62e65c5e381e208e70d4533d187d7fb61cfa4a7a99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18115a752f3777637541276711eebddf6ff22698170953f5adc27b8cd559d273"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18115a752f3777637541276711eebddf6ff22698170953f5adc27b8cd559d273"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18115a752f3777637541276711eebddf6ff22698170953f5adc27b8cd559d273"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcf0f8f25381db4e7e58e35a904718c89dcdafd2791a3f814b6ac81f64a750de"
    sha256 cellar: :any_skip_relocation, ventura:       "fcf0f8f25381db4e7e58e35a904718c89dcdafd2791a3f814b6ac81f64a750de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c0576d974f783ca0198f772a4ac9e91f9426f5f9cdcbaf13596778792db0b48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "434f08df2e259dd43d676ad47773285915481510d7dc9724598fe6716145c75a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/homeport/dyff/internal/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dyff"

    generate_completions_from_executable(bin/"dyff", "completion")
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
