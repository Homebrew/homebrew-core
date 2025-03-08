class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-6.2.2.tgz"
  sha256 "3cc183287c8cef68b1927100c5d1ca2e8e26f813cd14decbae909aa17cbe93e3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6dd00f948817b90ae38865595c888b4a1be8bdab87976915bdf8996576cd763"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6dd00f948817b90ae38865595c888b4a1be8bdab87976915bdf8996576cd763"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6dd00f948817b90ae38865595c888b4a1be8bdab87976915bdf8996576cd763"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3682567b0b43769b071368e0bf112662ea0aadfa67296a06f1dc216cac8ec82"
    sha256 cellar: :any_skip_relocation, ventura:       "c3682567b0b43769b071368e0bf112662ea0aadfa67296a06f1dc216cac8ec82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6dd00f948817b90ae38865595c888b4a1be8bdab87976915bdf8996576cd763"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
