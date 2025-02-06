class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https://github.com/mistricky/CodeSnap"
  url "https://github.com/mistricky/CodeSnap/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "f9ba0e36aab5c671f8068ca0d7bbd3cab4432f72096dbc6c425f4aaf9bc1b780"
  license "MIT"
  head "https://github.com/mistricky/CodeSnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17ca16883096a20e3cda88529115d8ef1a5f088fc0eaffb8d8e97161cb0414f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fa98da9b4c2b88d648449080060929b3000e70cdc9f7ebd5ffe9107aef7e283"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "341a5c76990f9725735ec11f9f53c420b63c03a67502bdc0884c373809ffd431"
    sha256 cellar: :any_skip_relocation, sonoma:        "95c4376735bb1299e6cafb91689294569875c33229f2ccbc6ecd128c6836b037"
    sha256 cellar: :any_skip_relocation, ventura:       "c64173e96b9d69335973405cbe3e97c25ce52a79a20a2d3810d271d5082dab32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0f10db20d9533ba7e0b6014703f2b20633c454fb89ca3ccdb90e7554195e777"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "cli/examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codesnap --version")

    # Fails in Linux CI with "no default font found"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "SUCCESS", shell_output("#{bin}/codesnap -f #{pkgshare}/examples/cli.sh -o cli.png")
  end
end
