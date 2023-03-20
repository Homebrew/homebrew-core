class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/swsnr/mdcat"
  url "https://github.com/swsnr/mdcat/archive/refs/tags/mdcat-1.1.1.tar.gz"
  sha256 "2757e1a26a7843c673c2aecd1866c1714af74883ebb0c4195384a62b6a7627ec"
  license "MPL-2.0"
  head "https://github.com/swsnr/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d44b7da6db8968782ee2f2506917696a8bef2fc0a15b68dfbe40699917bb7a15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "486721d5342ba4c199cac82e3cd77d5f88d9a7e310f1a223c4e8d5f190e33857"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e38293dd8f839c8b411f0064d5a4f40a1be3ebd497e67a6addd900648b03526"
    sha256 cellar: :any_skip_relocation, ventura:        "2f6548e52888c9bb30ecaea434410c186fbef5039cbe5ceac5df9de05620e805"
    sha256 cellar: :any_skip_relocation, monterey:       "35038125b6eced9cc1c99503ee7c35f582ccb5a57f6c572f3906287d68c7d602"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2748d1df871a8b85486020b53dc91a0e69dea6137b8af00814baa76934aee00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcdb4ba8bab35d809f9186d6a75c4af3ecc2b72480014d848e4c1695f732df22"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
