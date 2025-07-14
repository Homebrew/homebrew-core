class Dyff < Formula
  desc "Diff tool for YAML files, and sometimes JSON"
  homepage "https://github.com/homeport/dyff"
  url "https://github.com/homeport/dyff/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "8f20ba3580fbb45957211efdf5ac4fc60dd339a2f798db0ecf521c930fdb0be0"
  license "MIT"
  head "https://github.com/homeport/dyff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d709739f34f69642ebbadc8aa382b0ef0a4914593dbf31722ad409a79007fd2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d709739f34f69642ebbadc8aa382b0ef0a4914593dbf31722ad409a79007fd2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d709739f34f69642ebbadc8aa382b0ef0a4914593dbf31722ad409a79007fd2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "37093d31497ba88d80070b9aa1516f93f745d5b4e145a815bb93fdc3c161a5d3"
    sha256 cellar: :any_skip_relocation, ventura:       "37093d31497ba88d80070b9aa1516f93f745d5b4e145a815bb93fdc3c161a5d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86b077cc452fadf472c80a323c7fb655b0ee104aba3f9fe5fd46951d4f9896ba"
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
