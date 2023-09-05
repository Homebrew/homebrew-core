class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://github.com/pkolaczk/fclones/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "313d4dad30ed1db4d74abd78f30a7a9917c361918d2bc6d84c9d97a2a8c7c5cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9067e8185d41cf16f5d3bc29fdc2b3ce8f4edad185b3c9ec383ab06aa811cca0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03eff43c5ae76de8a591cc95a73ea5e0c65a689677d88e09f916da80606fa35b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14f6717c129313c4d7547dbd9019045d2a1104c42bbe5885350c84ddc7ab15ee"
    sha256 cellar: :any_skip_relocation, ventura:        "d5c29c8cde27f210b3980b15956bd1324c659e0c3651bf47db9038ff5295d901"
    sha256 cellar: :any_skip_relocation, monterey:       "e36b45ce1b8df565f6d3cad2524457cc5ac8ce8052f37b515b2f9f22c1dd17ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d92e888eb4d5636bf721e3cf195d2d8228a2ca3e1d4362dafa1e2d2469dc0a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fb8949117746fa9a7d854b2f075c7ca21397f257ae46e39a6e1bfad5202a4e8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "fclones")
  end

  test do
    (testpath/"foo1.txt").write "foo"
    (testpath/"foo2.txt").write "foo"
    (testpath/"foo3.txt").write "foo"
    (testpath/"bar1.txt").write "bar"
    (testpath/"bar2.txt").write "bar"
    output = shell_output("#{bin}/fclones group #{testpath}")
    assert_match "Redundant: 9 B (9 B) in 3 files", output
    assert_match "2c28c7a023ea186855cfa528bb7e70a9", output
    assert_match "e7c4901ca83ec8cb7e41399ff071aa16", output
  end
end
