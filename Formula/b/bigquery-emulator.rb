class BigqueryEmulator < Formula
  desc "Emulate a GCP BigQuery server on your local machine"
  homepage "https://github.com/goccy/bigquery-emulator"
  url "https://github.com/goccy/bigquery-emulator/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "44171bea8f46344da7a986df948215060bc50ba636a67bade94c01b2624c92fc"
  license "MIT"
  head "https://github.com/goccy/bigquery-emulator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2473b94d20723381f3df988205f3b56000a2d92764a8ec5247b95136e6095616"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4e32d26a2436802d94c079332711baecf47d4b49f8238076842c562ceea385a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2a45963fc5bfe24af67d506cd70802ac754597ff10ec19a7600afb2e4a8c1a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6d7910c66a6d3db21139c0dc0aa05744a4af2745dfa6a23a5c295f39bebfc6a"
    sha256 cellar: :any_skip_relocation, ventura:        "4a86f297c0185f786135cd05b3c4c371b62d3751f15caabb18e2486b3cdc7f34"
    sha256 cellar: :any_skip_relocation, monterey:       "91d3088287abdcc270e1ea7088e7f4d36a5fa5c51e314ddfb69fa0e85dc1dda5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bce408091cd9b0ab118452b6fd0d52bfdf4457067b1413757eac7a16208412a0"
  end

  depends_on "go" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "netcat" => :test

  fails_with :gcc

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = "-s -w -X main.version=#{version} -X main.revision=Homebrew"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bigquery-emulator"
  end

  test do
    port = free_port

    fork do
      exec bin/"bigquery-emulator", "--project=test", "--port=#{port}"
    end

    sleep 5
    system "nc", "-z", "localhost", port.to_s

    assert_match "version: #{version} (Homebrew)", shell_output("#{bin}/bigquery-emulator --version")
  end
end
