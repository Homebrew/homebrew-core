class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.54.1.tar.gz"
  sha256 "c083d8e883db287639c701286b892df9e4f192269c1179eba56ff1dba7114366"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "454fd6b4228699798f5fa89ff81dcb95b63d07f31c418e0c3007e4e23d2a0985"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "454fd6b4228699798f5fa89ff81dcb95b63d07f31c418e0c3007e4e23d2a0985"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "454fd6b4228699798f5fa89ff81dcb95b63d07f31c418e0c3007e4e23d2a0985"
    sha256 cellar: :any_skip_relocation, sonoma:        "83f7f70fd774a1f17b555f9660de19ce356211ad887f851abb2c41ada6eec8f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06b0ba786103b884bfb8a572a285f0fd90795a9f83a75f6b37844e693d225dbd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end
