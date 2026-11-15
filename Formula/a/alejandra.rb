class Alejandra < Formula
  desc "Command-line tool for formatting Nix Code"
  homepage "https://alejandra.kamadorueda.com/"
  url "https://github.com/kamadorueda/alejandra/archive/refs/tags/4.1.0.tar.gz"
  sha256 "cf74acd0bbbaa166abed6d155f3a6206392d715336e74f9bb5fe05d874de183b"
  license "Unlicense"
  head "https://github.com/kamadorueda/alejandra.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9f1336b2e798effd955c56b803afdb22fccbd436c462fc9869142cc600965600"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "723d97ac661b25897b67c83ed4200f29ecea06e07aeb14fcf0464aefe95cc9f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8a285b8b37eef4f19d409f042bb21c8e3ba33ab086d3310c5fbb6660d8ae0b65"
    sha256 cellar: :any,                 arm64_linux:       "cd6f46c33bc6811f44a321737104c06716787b265f206cdbb199215081d19b14"
    sha256 cellar: :any,                 x86_64_linux:      "cd793c00b7dbe1d1d24c99eb35dc649b2f61e3780cf2975376072ba2843050a1"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "src/alejandra_cli")
  end

  test do
    assert_equal "Alejandra #{version}", shell_output("#{bin}/alejandra --version").chomp

    ENV["LC_ALL"] = "en_US.UTF-8"
    input_nix = "{description=\"Demo\";outputs={self}:{};}"
    output_nix = "{\n  description = \"Demo\";\n  outputs = {self}: {};\n}"

    (testpath/"alejandra_test.nix").write input_nix
    system bin/"alejandra", "alejandra_test.nix"
    assert_equal output_nix, (testpath/"alejandra_test.nix").read.strip
  end
end
