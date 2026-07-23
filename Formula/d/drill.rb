class Drill < Formula
  desc "HTTP load testing application written in Rust"
  homepage "https://github.com/fcsonline/drill"
  url "https://github.com/fcsonline/drill/archive/refs/tags/0.9.1.tar.gz"
  sha256 "79e90ba78e484e15bf6cc919d0be5fdd99155ff2d5b16581539e4361191a8bc7"
  license "GPL-3.0-or-later"
  head "https://github.com/fcsonline/drill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5fe8459f6c6bf6d0f41b9e4344037bc1ec1ef675dab697f7d02d7a7fd1e1850"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5622dc4dca9eb03bcd4d038981ef8f3f5544e4402f167bde23d95fbd20d355b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cba26fd9736d68fee71942dfb45a7e6770de58eb07e0455e2e1e7f1528e7c7fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "802bfb72a5af8c62d64645f610370ad547bf06ef465720832360e3f0809bad1a"
    sha256 cellar: :any,                 arm64_linux:   "705357ccc4d65f57e2337488a8b7b78923c0a82c2ad6d06fed49deb325cbb08e"
    sha256 cellar: :any,                 x86_64_linux:  "3ef18d22cb195df8a89e00b249c7f307960afe21df45b543c6a51cc0f5f25683"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  conflicts_with "ldns", because: "both install a `drill` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"benchmark.yml").write <<~YAML
      ---
      concurrency: 4
      base: 'https://dummyjson.com'
      iterations: 5
      rampup: 2

      plan:
        - name: Http status
          request:
            url: /http/200

        - name: Check products API
          request:
            url: /products/1
    YAML

    assert_match "Total requests            10",
      shell_output("#{bin}/drill --benchmark #{testpath}/benchmark.yml --stats")
  end
end
