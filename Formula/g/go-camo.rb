class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.7.4.tar.gz"
  sha256 "5f9122ce87e665a37e1644400b8564a600f6db39f0f55eec9d72aedb5c867c08"
  license "MIT"
  head "https://github.com/cactus/go-camo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3775cdaf004afaa9096379550d8598b98ba61031aa9cd5bd07d90fec5c7cf4c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3775cdaf004afaa9096379550d8598b98ba61031aa9cd5bd07d90fec5c7cf4c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3775cdaf004afaa9096379550d8598b98ba61031aa9cd5bd07d90fec5c7cf4c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c41c6f262e3948feaf347face0f039fbfc64035ebb9271c01e6ded88331c451"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c29ac047d9ecd88c1d391c55a0c0f3faf4647b52af50a7ee7777292a2c489e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "213499ca24333786231325556a0009485d4f1ed88c04b31309139d91ea3560aa"
  end

  depends_on "go" => :build
  depends_on "just" => :build

  def install
    system "just", "build"
    bin.install Dir["build/bin/*"]
  end

  test do
    port = free_port
    spawn bin/"go-camo", "--key", "somekey", "--listen", "127.0.0.1:#{port}", "--metrics"
    sleep 1
    assert_match "200 OK", shell_output("curl -sI http://localhost:#{port}/metrics")

    url = "https://golang.org/doc/gopher/frontpage.png"
    encoded = shell_output("#{bin}/url-tool -k 'test' encode -p 'https://img.example.org' '#{url}'").chomp
    decoded = shell_output("#{bin}/url-tool -k 'test' decode '#{encoded}'").chomp
    assert_equal url, decoded
  end
end
