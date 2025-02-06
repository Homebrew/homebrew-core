class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "1c43110571f2624084e709d466f42a67c688a34120cc61842f4542b4095f74a1"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcb17f699e637fa086063b08bbfdc5ba83bc2df90f57ff0e9051ecff1f82e2fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "430f72fdf19b28b72d40218230a51083133e0d4e6c57aef99ca129f8e8f605dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6945d7b9c29dbcf0deab777151686763fc6db38970497bf2a7ef4eb93353972"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e4d12e67a78d8c93a14f29964a3b1bd522ff5459d62b208292c61eff8773918"
    sha256 cellar: :any_skip_relocation, ventura:       "759086a75988b48b88cb16e27fac834c1186383fb0b4690c11011dbf283bfeb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe1deef00dae16ca2076abe695f6bf88c4d60c5e8f7e4e0fd96c6238ab33506e"
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
