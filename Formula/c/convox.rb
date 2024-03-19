class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.16.1.tar.gz"
  sha256 "735ae0510b12aa0db985c44798ac15f318e196ba4b43a27535a2a55e2ea21484"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6fccc23f6346623cf8154ad34f287049fffa194ed08516cc81a49d952a33204"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37da0119a77ffb9cda55f8e9959dcc921bafaa760762e580fc1dc612da190405"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd8e6e16afe7ab40828c3d0982b458b8df0bd514e6dd50f4fd284b5e127383b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5896d90e01d6ffab270a5afd793693b0e974f851ed84d3fa592ba3fc7fa3c75"
    sha256 cellar: :any_skip_relocation, ventura:        "26af7583098b9d29bde3eeed49593b9edb0fc7af50d3711a461323f2f6a29662"
    sha256 cellar: :any_skip_relocation, monterey:       "3145dfb228b6f76d6a335c0a7f28bb43a07dbd2fa0e374755e75a6bdda5f6644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d40096a5df3dde66f4346cc846d0a521b9edb90ead322ccb82a9e2fa2b99a1b2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
