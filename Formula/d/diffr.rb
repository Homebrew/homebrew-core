class Diffr < Formula
  desc "LCS based diff highlighting tool to ease code review from your terminal"
  homepage "https://github.com/mookid/diffr"
  url "https://github.com/mookid/diffr/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "6c5861e5b8f5d798e027fe69cc186452848dc4ae5641326b41b5c160d3e91654"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "071c7a6bb8aa37bd0282e02096635a6aff9afb1e263dff03ae426a2d45351511"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "25cdb1a853eceeba0ce00dee4f2b5657abe9865ee7568a0cf18ee0b5fe95d3bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bc9706cc3bf1e99eda0b2138a3dbea9b4da2c097f4e4c421aa6249269146678"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "234e4932d849bec1ee31bc0caa455070caf78aa3839836ee15cce08546c72995"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "661cd6dd97c93e60266a8cf7a99240595b25dbf911efb143c4c5a60eb2c7d483"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d29fa319b7d851b24c147046018da33c98363de7439cee89b5eae6bfd13982c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b2001d7460d2d321838224631d7e1e06ca54e13e0276b69caeb39c4f5b6d76a"
    sha256 cellar: :any_skip_relocation, ventura:        "6d3a1af07c576b6db1522a77560bbe540a567a7339838dc5c660e7781a2302bb"
    sha256 cellar: :any_skip_relocation, monterey:       "d4d630b6e9973149bd9eb76134f9953ec0630274592ee4f5c1bce2d38de0b10e"
    sha256 cellar: :any_skip_relocation, big_sur:        "de79ded7a7f2b81026d2c8d5c9148ddc19815a953c10120b52874e52af9d25b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ce5653f762bcb8260b50f894f1c0a3b52549fd8e36baaf95c320169585b58c90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6340e51e0dd0f436f0cf3450d125f3a16b652cadf4b7de0fe9127ea7d90007b1"
  end

  depends_on "rust" => :build
  depends_on "diffutils" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    _output, status =
      Open3.capture2("#{Formula["diffutils"].bin}/diff -u a b | #{bin}/diffr")
    status.exitstatus.zero?
  end
end
