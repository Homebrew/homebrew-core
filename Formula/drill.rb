class Drill < Formula
  desc "HTTP load testing application written in Rust"
  homepage "https://github.com/fcsonline/drill"
  url "https://github.com/fcsonline/drill/archive/0.7.2.tar.gz"
  sha256 "cc33f5e214cf8c9c975bd2b912b87541eab2ceb34689fdc1f4882b332ad4ee44"
  license "GPL-3.0-or-later"
  head "https://github.com/fcsonline/drill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "904576a345557bad10f8d58dd20e009b055893d55a43049db32808ddd82a3c64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efc0e6a7ec33157683ee61e732ae5ddf6d8fa790192ed3c68403771cdc47803a"
    sha256 cellar: :any_skip_relocation, monterey:       "6113d7ea668ecf53bd2e8a60eef51dc48eaf1e0ae5ef8b6e4b17625ade71803a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a08286617629a63ebefc288604007facab0d3cd5a3a5b6c9caacf02db5f3452"
    sha256 cellar: :any_skip_relocation, catalina:       "3db1f9e4e0d25d84e5aa26e2801ea399f9328b50e32c85fa198894d5e5b54c3e"
    sha256 cellar: :any_skip_relocation, mojave:         "57509a9c9172333d4aebcc18d21476f835bb7fe240ca117c0df75b3901dda663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e2f5a4899c09e528fa4a45bead1d9a36f344a8c012f27dd6e5aea26a13c8fa7"
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
