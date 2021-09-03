class Drill < Formula
  desc "HTTP load testing application written in Rust"
  homepage "https://github.com/fcsonline/drill"
  url "https://github.com/fcsonline/drill/archive/0.7.0.tar.gz"
  sha256 "0041e4b8e8bae0bfc4dfc42b0d1c9a65a8a04dfb68766138d3ae85407e42b15f"
  license "GPL-3.0-or-later"

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
