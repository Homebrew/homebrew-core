class Dyff < Formula
  desc "Diff tool for YAML files, and sometimes JSON"
  homepage "https://github.com/homeport/dyff"
  url "https://github.com/homeport/dyff/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "eb0df6175ff66cc3494c856c2d70b980811bf3202b71be444209951458427ebf"
  license "MIT"
  head "https://github.com/homeport/dyff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca47694a87199dfc061233eac092100098bf724ec12f8ced0c02e390cc36f447"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca47694a87199dfc061233eac092100098bf724ec12f8ced0c02e390cc36f447"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca47694a87199dfc061233eac092100098bf724ec12f8ced0c02e390cc36f447"
    sha256 cellar: :any_skip_relocation, sonoma:        "13fc775ce170ed86b11a5ebd7fe5b7be96c97ecb1f4b7c37d4ced1706711adfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83349132787b8b7ec5ad5dcc0766debbcfa04d3f27b46cdf105c0fe82861dd00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98c6e2859997601c66a0b1602f7bbb9c32e06acec7d75c13b934841230b5759f"
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
