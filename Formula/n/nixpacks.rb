class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "e3df7388a5526b865546f5c1e81ca69cddc4bf263e6d4a063e5e3eaa29eb162a"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c38e987c689d3541714bb0ab66419a1b7aa28d10986853a2b7cc6cafec6e05e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffbd6d2eaba111636bd588a4b25fe98d5406d2be85f51af0431c48651f22e8cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d7eafbf4c24ac0799d9cf2eb1ba203fdbf4a65a352e871f6775d7015c6194d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "692c6324c4f6f4c92ad706d54b113722ee0e47c91ad351f8f2048ed7b854b653"
    sha256 cellar: :any_skip_relocation, ventura:        "57db72a0028a9b9c49738dcd8466a8fbeab0a3f508b0c0221bfd81180e8980ea"
    sha256 cellar: :any_skip_relocation, monterey:       "3744cf70eb4e6943565fe4b874327e657c487496426bdff0734b56faf445d78f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c60f32c618f2fb8b57b8eca826a964193f899da033ac9b96bc886d7d44322d0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end
