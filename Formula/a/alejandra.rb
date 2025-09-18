class Alejandra < Formula
  desc "Command-line tool for formatting Nix Code"
  homepage "https://kamadorueda.com/alejandra/"
  url "https://github.com/kamadorueda/alejandra/archive/refs/tags/4.0.0.tar.gz"
  sha256 "f3f9989c3fb6a56e2050bf5329692fae32a2b54be7c0652aa394afe4660ebb74"
  license "Unlicense"
  head "https://github.com/kamadorueda/alejandra.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee21f9015c2853fb4ccd0b5e8b8674c7d1c27ef9c17ff73771ca33f035a4eddd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a105b8e8c06f4e240b052d62e5b271e4a1c196f8367780ae22fe4bf705ad65b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e02b48f1e647cf69ccbb6846c8335f912cc08344f7107af6f3b4ad3780981f8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d220e43933b6412b9b2c55193af67aa046a935f282f7bb2bcbe73ce0987561fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "82324a20fbc443a94c675997c412c0394d9dc511f7bb72e9b36e1861deeee324"
    sha256 cellar: :any_skip_relocation, ventura:       "bbdac460582dfb76e32ca4976eae2ca4a58ab2ce5aa54091136040d9634b9af8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc7e20816b52cb47ab33221af91747fdf9e537a7b4bc252ed3aab37602cd4e65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34b9aa4a4f9d81bec8bd22b0f2199000be9469a732f3c140f5fabd7a4e766c04"
  end

  depends_on "rust" => :build

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
