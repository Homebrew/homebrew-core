class Drill < Formula
  desc "HTTP load testing application written in Rust"
  homepage "https://github.com/fcsonline/drill"
  url "https://github.com/fcsonline/drill/archive/0.8.1.tar.gz"
  sha256 "70e9c1b509a00da4ac23c92279cc94f6f7bd58918c187ae982fc674b66da814f"
  license "GPL-3.0-or-later"
  head "https://github.com/fcsonline/drill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f52cd08c09b0d24b2ec87387e4ed6a1dc66460dc4d3c10dcd400718ffbce81a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7b4433825dbb0805b99581c92f797170bbe96ea973859feaf3cf2bf5e6a00a8"
    sha256 cellar: :any_skip_relocation, monterey:       "0c7bdb0d36a979d56495d07233af47b3bfe373833591e620c8333c10158bc487"
    sha256 cellar: :any_skip_relocation, big_sur:        "35f3f0ee64c57c2eb4cc27c757eada8b5ba2f17c790baa86bb2f1048888df66f"
    sha256 cellar: :any_skip_relocation, catalina:       "d2a18dd4b009cde8029a99a0b8a8dad9582e23484938eca039afe4ddd9fa5912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "017593add7b77348f32eaa071c2ed94571bc377c8286b5c05f7fb2683cfa92ec"
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
