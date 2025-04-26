class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.21.6.tgz"
  sha256 "202c880cde9b73cc068a7bc2173a27ad128f203ed14a2b5c57564710b7171ac4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ef35f170850049c3aa763b9da9a8f10e63ea7aeeb867c5aff64a97f8110e8bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ef35f170850049c3aa763b9da9a8f10e63ea7aeeb867c5aff64a97f8110e8bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ef35f170850049c3aa763b9da9a8f10e63ea7aeeb867c5aff64a97f8110e8bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "45b2d62a7f91eb589fedb92019e83cfba8b94d4ebfd6a628d47f2b2d023ea7fa"
    sha256 cellar: :any_skip_relocation, ventura:       "45b2d62a7f91eb589fedb92019e83cfba8b94d4ebfd6a628d47f2b2d023ea7fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d870a7f4e292fb3a7e43a8a1781992fe79e70d47b34242eb706a40b1b89bb7c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d870a7f4e292fb3a7e43a8a1781992fe79e70d47b34242eb706a40b1b89bb7c9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_path_exists testpath/"storage/key_value_stores/default/INPUT.json"

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end
