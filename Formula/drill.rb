class Drill < Formula
  desc "HTTP load testing application written in Rust"
  homepage "https://github.com/fcsonline/drill"
  url "https://github.com/fcsonline/drill/archive/0.8.1.tar.gz"
  sha256 "8e31aa4d11898c801b6a47a6808b1545f1145520670971e4d12445ac624ff1af"
  license "GPL-3.0-or-later"
  head "https://github.com/fcsonline/drill.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61ab629d780af9ec0e8e6cdd2642f50d6e5c39e51eaa0e8ad65eb280f217c377"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e4f1a4918a076dc1b7a9c2503f76075dc6e66db028d4db7dded71b9454d6b03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5328f14dddd1d0f0808ad64034794275643cf902690c745d7a6b11ba73d4008a"
    sha256 cellar: :any_skip_relocation, monterey:       "94fed7fc60d7554579a78aee13749bf309481b6c35a79a41816438a6db832f07"
    sha256 cellar: :any_skip_relocation, big_sur:        "37611f137324359d6e8329b520a027468265a225bde909b33bc748a5e72217b8"
    sha256 cellar: :any_skip_relocation, catalina:       "6f93fbffcef67c34e531975dc653fe45a71a62f020d63265ea069f3c41fc5908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdde246989361f99943e1a64bffce747174f54efd654d0f52e6e5a8e59d08956"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
  end

  conflicts_with "ldns", because: "both install a `drill` binary"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"benchmark.yml").write <<~EOS
      ---
      concurrency: 4
      base: 'http://httpbin.org'
      iterations: 5
      rampup: 2

      plan:
        - name: Introspect headers
          request:
            url: /headers

        - name: Introspect ip
          request:
            url: /ip
    EOS

    assert_match "Total requests            10",
      shell_output("#{bin}/drill --benchmark #{testpath}/benchmark.yml --stats")
  end
end
