class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://github.com/davidesantangelo/krep"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "536342ce821bfaa4afc37c19d96cc54a37755a866b6564dc825be7a0a242a068"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2e7297f52dfaf421dab80f7771b1d5a964f8a17353881845b683eb39da2ba68d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "369e912d24bdb71e79c1167f3e4b54a163a2c678be0f82ba01dd6b60be89b79f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7045f45ffc399c428c31d5c9adc59095765b17fe732e3e9a66f466b7991255bb"
    sha256 cellar: :any,                 arm64_linux:       "2d257b612e6290fea99ce1c9fe01736754b5730fe4abc209e34ed8f2827d66f7"
    sha256 cellar: :any,                 x86_64_linux:      "654237f1367c27faecab1c7c4c0244cacf939fca00ef121b66a9d59bffd11941"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/krep -v")

    text_file = testpath/"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}/krep -c 'match' #{text_file}").strip
    assert_match "1", output
  end
end
