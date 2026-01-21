class Goread < Formula
  desc "RSS/Atom feeds in the terminal"
  homepage "https://github.com/TypicalAM/goread"
  url "https://github.com/TypicalAM/goread/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "9b08cae05593034711c599b6b17605194a11bbfae769b4e7e0076a01ec197c37"
  license "GPL-3.0-or-later"
  head "https://github.com/TypicalAM/goread.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3f2abcbf279010d6288ba9103f6f06e98f06293bd5b175fd047e4529cdfc644"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3f2abcbf279010d6288ba9103f6f06e98f06293bd5b175fd047e4529cdfc644"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3f2abcbf279010d6288ba9103f6f06e98f06293bd5b175fd047e4529cdfc644"
    sha256 cellar: :any_skip_relocation, sonoma:        "872638c548cd01fdfac5d2067ffe292c69f4de26daf2e3082c03be0ce6317341"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8135fd745a08cb6fcc5c594068d20f4473f825f000ab5d3dfb073fd3be9f143a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aff2dfdb38dc38094eda152368a17a74174e146cb1bd7709ba11ec28ea26550b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"goread", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/goread --test_colors")
    assert_match "A table of all the colors", output

    assert_match version.to_s, shell_output("#{bin}/goread --version")
  end
end
