class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Golang"
  homepage "https://github.com/context-labs/mactop"
  url "https://github.com/context-labs/mactop/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "18a44c34a0915141ce4a628ef061c82b24eb25c7fb44ee761a332fd39cb688a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8285894c895d812c9ac8100025bf4054ef41a4a006f97e9fb38d9567b1c158bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eee6a9414367242c091997b966626244b3e8ffc24d86379ca6cf563ffad2858a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "892970e34a50d96aed3564a18bcf69ffe448d71ef4e27b096166284e060a5287"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  def caveats
    <<~EOS
      mactop requires root privileges, so you will need to run `sudo mactop`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    test_input = "This is a test input for brew"
    assert_match "Test input received: #{test_input}", shell_output("#{bin}/mactop --test '#{test_input}'")
  end
end
