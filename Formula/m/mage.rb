class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage.git",
      tag:      "v1.16.1",
      revision: "b94953dd0f45774ee618484152549dc0742f2ba4"
  license "Apache-2.0"
  head "https://github.com/magefile/mage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "852f1940a3b6e1ab1ddb2f133f9560344ef58f41f26bf2c51737aa218e2ea2e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "852f1940a3b6e1ab1ddb2f133f9560344ef58f41f26bf2c51737aa218e2ea2e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "852f1940a3b6e1ab1ddb2f133f9560344ef58f41f26bf2c51737aa218e2ea2e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a0c461581c9c72035993106184814e693e994ee0945f70845daee18f62e9c5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6881f54bbdfcd0db6f6dcb8005bb7261eb5141b2ec8aea41f3b04c748b8ec8de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "891a6580acdd7bbb8f814ca60068acee05b50bf0dd0ec8fc5e2c6f03ff11ed59"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.com/magefile/mage/mage.timestamp=#{time.iso8601}
      -X github.com/magefile/mage/mage.commitHash=#{Utils.git_short_head}
      -X github.com/magefile/mage/mage.gitTag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "magefile.go created", shell_output("#{bin}/mage -init 2>&1")
    assert_path_exists testpath/"magefile.go"
  end
end
