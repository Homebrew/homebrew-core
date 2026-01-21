class Ekphos < Formula
  desc "Terminal-based markdown research tool inspired by Obsidian"
  homepage "https://ekphos.xyz"
  url "https://github.com/hanebox/ekphos/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "b7ac48edd5b106e58048b1170192430942b23520e62720d20d0b729952f7c7fe"
  license "MIT"
  head "https://github.com/hanebox/ekphos.git", branch: "release"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "739265dd032bd1694bc74c18175852fc0ff76fe40447b5f0086ee8159aae6bfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df9d781adeda3d5116f285818f52a2c92461f5198abca4d3b7280ff4ac575b02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eeccd57344199b178c882700a683bd89d8da37d8a2f5812c9c5a176a329bc5f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "745495bd64b18f09975c6fd9752f630ea966eb958a363f1351b779f544294d44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c235ffb5031d7563835caa7204da2c61ab90337c3a45c2d11cdf8e2738e871e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca9a6a5f314b26f58c130aca329aa1f23b6278489ff917caeb2dbc12e4168351"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # ekphos is a TUI application
    assert_match version.to_s, shell_output("#{bin}/ekphos --version")

    assert_match "Resetting ekphos configuration...", shell_output("#{bin}/ekphos --reset")
  end
end
