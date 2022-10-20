class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.45.0.tar.gz"
  sha256 "d3bf43e9061b9fb3c66f23faa91c3eefe4074c4121ad403133303d2bab54bdb6"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a47bb9de90570b0d115263a3e4efcbd3d1c427b519c3bb2b3d74856c596c53d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04659e17ca09520fd924e884b09236d4a0291499f591bfd0099c68c959d07f38"
    sha256 cellar: :any_skip_relocation, monterey:       "33e114dc268a16214829d23d39fb68e9b5de4daac2824113dccb742b8b297eea"
    sha256 cellar: :any_skip_relocation, big_sur:        "a19beda669f9fd396d34002f28ba9a1a89fe5823ec340ef4de228255e47962f0"
    sha256 cellar: :any_skip_relocation, catalina:       "030fd1c356bc9d7b622a6428a7d81b2968f31024afb87db4a97082dd5cb5f65f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "769143fb81bc1e78819a1f5e478c73ebfa79cb0d6fd2666c8873d31b0c9b5141"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
