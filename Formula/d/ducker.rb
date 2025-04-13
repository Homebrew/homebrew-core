class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https://github.com/robertpsoane/ducker"
  url "https://github.com/robertpsoane/ducker/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "122026ec9d835ded2f623993918e25ef60f753a7e1210d73d3d1d3728836ecb8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "879ee0904c0c8d6604d6c4df86566910b0934c304a3f47d1903e09af01a734c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de041d0416d502a00f6fc6431cf742f5c796683a709aa95cfe764f340f280494"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f2d51a8877db9e944e862e8f19d6372f0bcee65cbb59ddc06a6b284d56c74f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a06955cdf22f6b67ea433a47be4b070f399bd9d272e074ae432b2f8184fee7b2"
    sha256 cellar: :any_skip_relocation, ventura:       "613bef7394717defcb7ddc43b29bfb72c4ace6a6c4e4298d0a6c3111127af2f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1191adb12ed76927e47accc1b7df8234603c7603ed65e4f0bafc7fd89199220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23dbe74594546f8e990291b4ade931849aa513f5c775d44c04859243fb760927"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/ducker --export-default-config 2>&1", 1)
    assert_match "failed to create docker connection", output

    assert_match "ducker #{version}", shell_output("#{bin}/ducker --version")
  end
end
