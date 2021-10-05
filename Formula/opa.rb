class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.33.1.tar.gz"
  sha256 "94bfa19c5dfb2a1e5b8756543c067d1eebc7f0df7aff854a0678168b789100dd"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c68d44ab0edb729bc222bc50f012f06dab6afec418297dab02840b7699a67ea"
    sha256 cellar: :any_skip_relocation, big_sur:       "f4e79dc2af2dc4ea53ef2d1067ac61b74c147b6ff9158134fedd318789aabee3"
    sha256 cellar: :any_skip_relocation, catalina:      "0eb11867a945da74aa6c965773bc5ad84d664c491760820577bc9306b1e9c333"
    sha256 cellar: :any_skip_relocation, mojave:        "5219518811b060b2a3eb0d0861a5066bd1de5d9b0fef55fd2fe01035100d3c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee0ced4b44669166c7f07f24ff94a27e1a31f6137a40673e4a8289e1a66fae69"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
