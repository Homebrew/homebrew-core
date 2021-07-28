class Codefresh2 < Formula
  desc "Codefresh CLI tool, V2"
  homepage "https://codefresh.io/"
  url "https://github.com/codefresh-io/cli-v2.git",
    tag:      "v0.0.39",
    revision: "e917251dceff00e172ad38d77fc22ff7016c64a6"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "make", "cli-package", "DEV_MODE=false"
    bin.install "dist/cf" => "codefresh2"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codefresh2 version")

    assert_match "must provide context name to use\"",
      shell_output("#{bin}/codefresh2 config use-context 2>&1", 1)
  end
end
