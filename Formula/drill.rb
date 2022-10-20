class Drill < Formula
  desc "HTTP load testing application written in Rust"
  homepage "https://github.com/fcsonline/drill"
  url "https://github.com/fcsonline/drill/archive/0.8.1.tar.gz"
  sha256 "70e9c1b509a00da4ac23c92279cc94f6f7bd58918c187ae982fc674b66da814f"
  license "GPL-3.0-or-later"
  head "https://github.com/fcsonline/drill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0b4313cb4832e360a70f570affa8de41b10c3ee811c09f8aab13f7cd7a7ce71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e43c6d9e3ef9ca48962b7951afbb98dd6dc38d57821d618cf8b6dc4a2ca9083"
    sha256 cellar: :any_skip_relocation, monterey:       "4803852249e8bc6b3b8e4670e4bc4c3c7760c2ba836376a56beb1726eb5f5321"
    sha256 cellar: :any_skip_relocation, big_sur:        "2fcc32b1d88e24a1194a74792da6a8f3f0e914407c44a4996ad18e9f89e44559"
    sha256 cellar: :any_skip_relocation, catalina:       "28ba37e907b166f55c3c17a0a598fcf1c56214f906c99aabcb607a4d9c40696b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbfe9b9c63b2fa46ed44ac9823d72e3f6fa53bc7649bc9c2583b2e578fc2236e"
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
