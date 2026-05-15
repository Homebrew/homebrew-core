class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.76.tar.gz"
  sha256 "9fcf89f07dc9774112c82903bb108831758e42703ed37c42385506fcdbf19d89"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc8c7001049799b9adbd0ab502ece421d944b99994d24ca5a2452453924aedc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc8c7001049799b9adbd0ab502ece421d944b99994d24ca5a2452453924aedc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc8c7001049799b9adbd0ab502ece421d944b99994d24ca5a2452453924aedc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "025e56e0e96fdefa587df0794c13916a35e59edaba104803bdcd71906b56e685"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "684a002326f6c87fd54d23caf379f240e7b77d48213afc242fc5ca357e502a26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b03aa67a10f443c2aa7290ed87338645e69d9b2583c714e2420f1af4c35a1e3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end
