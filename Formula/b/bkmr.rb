class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v4.23.8.tar.gz"
  sha256 "e4839725fb6daed5dcac178fda745472a74afcf11a6ca2d5b15da11f72a2c00a"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a464f0b2e3615a4c2308fc6dab1992e787b798bc5ce2615a00ba9c61db54d39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bd992e0ca47a209537db27edc10d195f0fa2e924bf0b5703ce1786cba700375"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8f19349204e6790176ec28bfdad2ba1d2ed7013d05f746798dd8de29c4c0f77"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f16d46b4f6db594c9b02407474e17b0b3004fd0e924dd6edae75c5f9a2b7dd2"
    sha256 cellar: :any_skip_relocation, ventura:       "f732549eabc46ce84d6f9c69e8c46902506105ddff7ad13a65f49088d61aa190"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34b92a2b29d33be35d6a55dfc88c151919309d60f3bba4f173bcea6051508020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71f7292c127c1da61348d5bf382c5c35750692b7f6265fcc64d3fcad20d9b5ed"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https://docs.rs/openssl/latest/openssl/#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      system "cargo", "install", *std_cargo_args
    end

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    output = shell_output("#{bin}/bkmr info")
    assert_match "Database URL: #{testpath}/.config/bkmr/bkmr.db", output
    assert_match "Database Statistics", output
  end
end
