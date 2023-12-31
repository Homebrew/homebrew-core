class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "0f2cdd80879dc97d07ffb36a84aaf56f524b1466f88276afd210cdcc9f07e462"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7664f754b0e1cd00a7dfad32d3a28ae2fab4b866319d61b0b7463a26e82449d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66384fb6f9f658ad0bb0fda4830f7f59534f9fff1e2fd80abb1a006acb966cb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d01513e11878090aa8761356810cc9e66eea0eda211221926ff5ca671701954d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4146d4cf58814aaa912b2fc71f369071f0b39d80d4dec50d657ba08e1959a56d"
    sha256 cellar: :any_skip_relocation, ventura:        "43cc782f27c970643de52386ec32dab18e550e81553f564128877df977973c93"
    sha256 cellar: :any_skip_relocation, monterey:       "88d4b11ba408b0a5d40d2a83a43f9d7a17ca16b96cc0cb199a0bc5c2b2a34c21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ec11b836b33f88b0948be208ecb7e8184adc3bc2336437ed08088f7b189e89a"
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
