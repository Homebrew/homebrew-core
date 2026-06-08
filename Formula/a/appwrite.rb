class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-21.0.1.tgz"
  sha256 "af79417d56ecdcc9bad6d7a805c2a967e013d04f38a3a95681b95994135e2d16"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51f537279f972c970a46b2003d254c03a055d768c8459e1cc82753525e85c04c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ac4a45dedfebaa095f696f4b7b5aefc1a0f3bbe09429f763caa48fece113890"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ac4a45dedfebaa095f696f4b7b5aefc1a0f3bbe09429f763caa48fece113890"
    sha256 cellar: :any_skip_relocation, sonoma:        "49e403c2fdc661aa3e35a20e2af3cc3e0e16c695753df17ca60be9e66d20ffb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a787b01e9dfe15c0f04b8602a000de3588bc135817203d7dd2846c3b33a149f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a787b01e9dfe15c0f04b8602a000de3588bc135817203d7dd2846c3b33a149f0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    machos = %w[fsevents/fsevents.node app-path/main]
    machos.each { |macho| deuniversalize_machos node_modules/macho } if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
