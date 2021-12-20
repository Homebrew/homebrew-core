class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.10.tar.gz"
  sha256 "20b4cd633e0d7e72bdb3e9e4018f1342acfea6b22fd271c90bc915d2339e8e6b"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20f37cfb00100b2b219b90bf858b71a2aa8623da37df5fb571dca2aaae1a3b2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc204eeea17a756f19656f35063222b86a5385da42a74c38c8d7e8f0d3acb57d"
    sha256 cellar: :any_skip_relocation, monterey:       "af794d8013df1e9bd90b2d9eeaad0e3500fa56cefcb3377bba85d0eb23c14154"
    sha256 cellar: :any_skip_relocation, big_sur:        "26d9eefce93f207b12ef3906fcb89afeb62a4fde3bb2044e6f7a07078214bcce"
    sha256 cellar: :any_skip_relocation, catalina:       "3e2e73ae0eea8536a6cd3f42a891a64c8c7baccb26298cdee59df1123b3cc06a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a025202476a857f9c1a2f780197a1de690f3ebd93a0c08e0d76576e34d1cc3c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
  end

  def install
    cd "duckscript_cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"hello.ds").write <<~EOS
      out = set "Hello World"
      echo The out variable holds the value: ${out}
    EOS
    output = shell_output("#{bin}/duck hello.ds")
    assert_match "The out variable holds the value: Hello World", output
  end
end
