class Drill < Formula
  desc "HTTP load testing application written in Rust"
  homepage "https://github.com/fcsonline/drill"
  url "https://github.com/fcsonline/drill/archive/refs/tags/0.9.0.tar.gz"
  sha256 "ac486698c33daecb2d099fbb890d0b37ffd9baf3655d620f57932e1d398b44fc"
  license "GPL-3.0-or-later"
  head "https://github.com/fcsonline/drill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13ae6a7c0008708c01518af46e904e89ad976758c366d4e01b532b705629bf57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcb1d6d7ba6a60c0b61a263bf89f8bf92e08f8c9086720640b9db232b741b430"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea68c80898ceea9c47daf7984c9fec885994d83c2c79c926ae5c60edf06faaf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a0743d5cb645e6323ed57e8775844a617e967f9b9736862a4065101617c0a96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5dfdcd4ad9eb746c6742df724fa52365cf9284c14abd4dc4de5a76dcfb00ca6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6aa7af21ce2ba9c1963ba394dd94bc2f34156e93cb3a150faa794f0a0148e79c"
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
