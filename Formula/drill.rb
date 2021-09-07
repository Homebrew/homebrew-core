class Drill < Formula
  desc "HTTP load testing application written in Rust"
  homepage "https://github.com/fcsonline/drill"
  url "https://github.com/fcsonline/drill/archive/0.7.2.tar.gz"
  sha256 "cc33f5e214cf8c9c975bd2b912b87541eab2ceb34689fdc1f4882b332ad4ee44"
  license "GPL-3.0-or-later"
  head "https://github.com/fcsonline/drill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4332ccf85b364c2cda268ad8e932594a999dc6c6a911e77a7cf5fff2df5eb628"
    sha256 cellar: :any_skip_relocation, big_sur:       "e369fa62911fb9814e1f09c850c2701a977661bc05c867edd1fa0952e0a3571e"
    sha256 cellar: :any_skip_relocation, catalina:      "a02f8a76c87dcb3b40016d4fec501ecc6098faf6e39f89f04d885d4cc95a63a5"
    sha256 cellar: :any_skip_relocation, mojave:        "b646e08b2cbea5f15d1482d7f6755d432166c744146e88682df350169fa204d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "378aee56501b6262d6e9f1eb7168067a8d5d68f4fd16fa2f241a141fd2ca9c3c"
  end

  depends_on "rust" => :build
  uses_from_macos "openssl@1.1"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
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
