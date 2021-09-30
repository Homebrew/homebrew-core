class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.33.0.tar.gz"
  sha256 "549217aa54f1e6ab0bee7ebc80a5f8773fd54b974b9a319dac71509aa642bbb2"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4bbec854e1b10456b57ca89bcc965d6c925a22989a8133633d6744dcef1b50b3"
    sha256 cellar: :any_skip_relocation, big_sur:       "b7e65fdd1fcea223595de46426a90e4f9e24621adbe3df32ca8092b8b666c94e"
    sha256 cellar: :any_skip_relocation, catalina:      "0f1d5fb8e291ae1a9cee81621a73bbf18e8f324fe612744686fbbe98065ad054"
    sha256 cellar: :any_skip_relocation, mojave:        "46b7fd1c05604c03c21d1142810e9bc7ce92939c1242f0d9f946ae4d40e2ef80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2a3804acc4f30223e92c11e9bb64c37bad63644f8d8371a1d3169663887101c"
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
