class Cdebug < Formula
  desc "Swiss army knife of container debugging"
  homepage "https://github.com/iximiuz/cdebug"
  url "https://github.com/iximiuz/cdebug/archive/refs/tags/v0.0.11.tar.gz"
  sha256 "c036605bd6d6005cfb5355ed432382b37ea4d59c835d986d861b7c2205443ed6"
  license "Apache-2.0"
  head "https://github.com/iximiuz/cdebug.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5cf4d64fad5499a035d62663395ad7144ba3fb1ac52223a8712cb387f9af2c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33d3f8e72ecfb7b91db1f01cb1a4102aec1cdc765027457c348436c7318b831e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "000bc4559cdf6fc55217466c6e9b639ac11dc14ae9af3af9bc8d70a15d5a724d"
    sha256 cellar: :any_skip_relocation, ventura:        "893f326aab5ebf9f10815a42fba3c679ce3d35144e786dbcc88ccfa5dc2aed61"
    sha256 cellar: :any_skip_relocation, monterey:       "78f58e5fa5981b6c77835bdc492d57ddc3bf01add741a2e0e42bf4e489e3ff47"
    sha256 cellar: :any_skip_relocation, big_sur:        "f71c5a3bd1f65c0f9ecbbd39cf8f69c4bab64b999a94120896d7242cb6ac3b00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b6ae43c8e72c6cba922665690e7f6c2ceed8a405671f744782ba8dabf64eadb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"cdebug", "completion")
  end

  test do
    # need docker daemon during runtime
    expected = if OS.mac?
      "cdebug: Cannot connect to the Docker daemon"
    else
      "cdebug: Got permission denied while trying to connect to the Docker daemon"
    end
    assert_match expected, shell_output("#{bin}/cdebug exec nginx 2>&1", 1)

    assert_match "cdebug version #{version}", shell_output("#{bin}/cdebug --version")
  end
end
