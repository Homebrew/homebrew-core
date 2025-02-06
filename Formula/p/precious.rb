class Precious < Formula
  desc "One code quality tool to rule them all"
  homepage "https://github.com/houseabsolute/precious"
  url "https://github.com/houseabsolute/precious/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "dedb229dec25ec2d8ce627c65aa4a7625af2373456d2f6e76489990b917a248c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/precious.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7371fbd7a185afb9e1a7438a7e51dc7c0a861597927476a571b7f0e63a6691c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6e85972cd7c3a34557ff480ffee877de202d62ded560a7a3335517c811b14e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41c7139270cfa152364cc526d2bd163311a43557046a06a1e48db16bb02774a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f397c5e547dea9e3658f1b3575ac930d6aa5ea50e16fd338c87083192af00989"
    sha256 cellar: :any_skip_relocation, ventura:       "e182c780c571848492d2e20c37161e2b397d58215dfdc3bc759d9bf0502bdaef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2ae3221c1c095fca0dd1b4bd3b38ded721723f55a5649f5f2b5e928aab369be"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/precious --version")

    system bin/"precious", "config", "init", "--auto"
    assert_path_exists testpath/"precious.toml"
  end
end
