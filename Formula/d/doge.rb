class Doge < Formula
  desc "Command-line DNS client"
  homepage "https://dog.ramfield.net/"
  url "https://github.com/Dj-Codeman/dog_community/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "21d459f1f88d6a1e001a747b84782f180c01de8f3c39f3a1389c352b2f2edc88"
  license "EUPL-1.2"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1b0e18f93bb0fc4b1919efd31251f88ea5594bfe4b33b9403bb88f678965e1ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b09148d5fa1c4730220c64f1958f1e41c339d7d8d0755081b3630b92cc992f2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e4ea11990dae5172828276d789e317f3f597085b8ca3f7c50d286d0437d8b5da"
    sha256 cellar: :any,                 arm64_linux:       "385f666cdc023449fc6cd82782069803b8da0c91217bfbfd5974c4ceb42ef472"
    sha256 cellar: :any,                 x86_64_linux:      "ffc3ba94995be2c48b622b76fb9992afdbd71e54d907c58d2d370c692f00d3f1"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/doge.bash" => "doge"
    zsh_completion.install "completions/doge.zsh" => "_doge"
    fish_completion.install "completions/doge.fish"

    args = %w[
      --standalone
      --from=markdown
      --to=man
    ]
    system "pandoc", *args, "man/doge.1.md", "-o", "doge.1"
    man1.install "doge.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doge --version")

    output = shell_output("#{bin}/doge dns.google A --seconds --color=never")
    assert_match(/^A\s+dns\.google\.\s+\d+\s+8\.8\.4\.4/, output)
    assert_match(/^A\s+dns\.google\.\s+\d+\s+8\.8\.8\.8/, output)
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index fcffb94..200fab4 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -470,9 +470,9 @@ checksum = "3fdb12b2476b595f9358c5161aa467c2438859caa136dec86c26fdd2efe17b92"
 
 [[package]]
 name = "openssl"
-version = "0.10.72"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "fedfea7d58a1f73118430a55da6a286e7b044961736ce96a16a17068ea25e5da"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags",
  "cfg-if",
@@ -511,9 +511,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.107"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8288979acd84749c744a9014b4382d42b8f7b2592847b5afb2ed29e5d16ede07"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
