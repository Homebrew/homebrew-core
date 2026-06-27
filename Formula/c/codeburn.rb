class Codeburn < Formula
  desc "See where your AI coding tokens go - by task, tool, model, and project"
  homepage "https://codeburn.app/"
  url "https://registry.npmjs.org/codeburn/-/codeburn-0.9.14.tgz"
  sha256 "690a83e0a19bec4c5440858c66e4e6880f289d6905bc7fd18617bffa4bd4bced"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05d85eb05ad9867bd0f7bd12d9c7d06996ec5f2799566e65710565eeacc5c85d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05d85eb05ad9867bd0f7bd12d9c7d06996ec5f2799566e65710565eeacc5c85d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05d85eb05ad9867bd0f7bd12d9c7d06996ec5f2799566e65710565eeacc5c85d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc879ae8e634fb17d29fdd4967891f62e87888ffc9f7f62a004afd93385c361c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc879ae8e634fb17d29fdd4967891f62e87888ffc9f7f62a004afd93385c361c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc879ae8e634fb17d29fdd4967891f62e87888ffc9f7f62a004afd93385c361c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/codeburn report --period today --format json")
    assert_match "\"generated\"", output
    assert_match "\"period\":", output
    assert_match "\"overview\"", output
  end
end
