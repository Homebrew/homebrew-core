class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.6.1.tar.gz"
  sha256 "14008c3056217a758883e0b65589fc8ce699f245e9f1c1ff5aad925c090eda37"

  bottle do
    sha256 "e5d77a30f9da1abe166abbcdc93973a4d16ff21aed94b8299c221ba46d6dece3" => :mojave
    sha256 "cf6e33213638fa2af711716699be00bf7241da43d3188548c3be755d76ab0d56" => :high_sierra
    sha256 "06b080d96358726dd8e97fae6f40eeca77616130953d2ab09c756d22a7358633" => :sierra
    sha256 "420bd7bd4e960b0daaa69fb0b978e145982ad20d853898cc86b00c1d1d022385" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
