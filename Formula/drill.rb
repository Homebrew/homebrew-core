class Drill < Formula
  desc "HTTP load testing application written in Rust"
  homepage "https://github.com/fcsonline/drill"
  url "https://github.com/fcsonline/drill/archive/0.8.1.tar.gz"
  sha256 "8e31aa4d11898c801b6a47a6808b1545f1145520670971e4d12445ac624ff1af"
  license "GPL-3.0-or-later"
  head "https://github.com/fcsonline/drill.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21deb8530364edfefd6e57edb775ab2d1ea06ccbc0d2e31f9157e6d881c9ac5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1220b15bd94b28684668313f12c6d7bf34b6ecfec8f1ac3b53402215b5d8f76a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08f996237343ffeda4443f85ec63e2a4aae6e7a5e42303b8ab2c0139a4508b13"
    sha256 cellar: :any_skip_relocation, ventura:        "f188097a1cf43ff2a46681a603c92f293920ea13df4bb8ce85821eace7b9f715"
    sha256 cellar: :any_skip_relocation, monterey:       "64d6efe6453d35b3fdc0b50e330b23eb75ac307fc86ea8e723257e37a0251fc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "307d80b6b1a87adc2ef5d5e6e4b56348f0540dfa8fb22d70916ff4c14e9cd158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d9238aa3de59d7c0c9e52bd438dfe63d1b3034b84c5a4d1063ee015148c0106"
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
