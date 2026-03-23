class Codevis < Formula
  desc "Turns your code into one large image"
  homepage "https://github.com/sloganking/codevis"
  url "https://github.com/sloganking/codevis/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "a4578a1218fc82be8866defe49db4ce6a23088446c18ca3494d3ebc16f931d3f"
  license "MIT"
  head "https://github.com/sloganking/codevis.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b343098901a405f0c2b847cb154a759404fb0959aad0ce0acae6041394190b79"
    sha256 cellar: :any,                 arm64_sequoia: "809aab83526ed594b872942f4edb8cdae2530d7f9abb37fcf148690bf37adbe0"
    sha256 cellar: :any,                 arm64_sonoma:  "51ea40fc3d8a3ec373285257f809f4b3eb034b1ca70fd8929600c71df31ae06e"
    sha256 cellar: :any,                 arm64_ventura: "ea1a0d87b40ef80b9703fd13aea536c990a22486e29ffd3da58fe69d358d67ff"
    sha256 cellar: :any,                 sonoma:        "fb7c8b97b77b706314852bd71838810c67e783903409ce94edf69b00ad1a36a4"
    sha256 cellar: :any,                 ventura:       "acc82b560737c762384696f71560573a66d2327f827265819ebf99c52851bdb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85a8bfe022daaca844396a7daae091b2e374f5d83b7d15149d6a47bd414f3269"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de3939e0b77b99e6d62c786955215be6273d5cedae6ccc7e63c3b9a775f7c2cd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codevis --version")

    (testpath/"main.c").write <<~C
      #include <stdio.h>
      int main() { printf("Hello, World!\\n"); return 0; }
    C

    output = shell_output("#{bin}/codevis --input-dir #{testpath} 2>&1")
    assert_match "search unicode files done 2 files", output
    assert_path_exists testpath/"output.png"
  end
end
