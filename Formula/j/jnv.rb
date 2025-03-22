class Jnv < Formula
  desc "Interactive JSON filter using jq"
  homepage "https://github.com/ynqa/jnv"
  url "https://github.com/ynqa/jnv/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "45cf21e6f33ea6c40a52d6d281a4ac4b67bcc02f8de6d615a56ad150a27ed666"
  license "MIT"
  head "https://github.com/ynqa/jnv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d01a95c658e9704e2ff8356c94ab58625571f9dcff6ea616b558e6f6c2cc61ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c688c552454c6bfd534d75c20f8dbe8745c846a456e4c150bdc7aa8ad03602bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73d2990fed120cf65fecc358b2da15447ab4540253ba21908f3ff67c69d76791"
    sha256 cellar: :any_skip_relocation, sonoma:        "b33c998f4f590c6363fd450fd4bbdcd7115d6f1a7302c73016a4b2cdcd4eb946"
    sha256 cellar: :any_skip_relocation, ventura:       "ce13308a377d7f3d19095a57a178ab5cfe770b0a590659f97fb6cefbee41296c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b62612be90c9690884b9256a226c3131d8171ddc5d56d7e3065327e2ac44f606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ff26530bbe19dc29210440a2a9459583d56e6026291f80e63058c95aede0f5e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin/"jnv --version")

    output = pipe_output("#{bin}/jnv 2>&1", "homebrew", 1)
    expected_output = if OS.mac?
      "Error: The cursor position could not be read within a normal duration"
    else
      "Error: No such device or address"
    end
    assert_match expected_output, output
  end
end
