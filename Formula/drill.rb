class Drill < Formula
  desc "HTTP load testing application written in Rust"
  homepage "https://github.com/fcsonline/drill"
  url "https://github.com/fcsonline/drill/archive/0.8.2.tar.gz"
  sha256 "6e03fd2e2a80a9eb9a539b7a9ea4f5fe8733ae516687755fd0f8d788301fb83f"
  license "GPL-3.0-or-later"
  head "https://github.com/fcsonline/drill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3aab1d5ab31f25ad661667a52ebbecee47b07cdcc583cd64d79bbcecdcbe7ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cda358f38a686ffa01cd83ce24612dbe03b48211a11bfc8c21c2b759f0e1f8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07e27776d3d25c4b3af589b6f95f06dbd6cd31cc54aacbc7cec63e6951c98475"
    sha256 cellar: :any_skip_relocation, ventura:        "14c1d77c991bbd89e8c2d7b2e50d10b770c89a394cc93f40ccf0d3c1f8d25305"
    sha256 cellar: :any_skip_relocation, monterey:       "c49a9264ad149367b7c8ee1b5fb1fe8797cabad2107962e23c11cb1615592502"
    sha256 cellar: :any_skip_relocation, big_sur:        "dde4e771d2a7fd8aef40b921433b05e8b20fa3e14686b5bf9d05532564f304cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a88da29fbd3c641f331399f2575282d6a1feb513620c7300d2f32125595550b5"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  conflicts_with "ldns", because: "both install a `drill` binary"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix if OS.linux?
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
