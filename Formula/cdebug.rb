class Cdebug < Formula
  desc "Swiss army knife of container debugging"
  homepage "https://github.com/iximiuz/cdebug"
  url "https://github.com/iximiuz/cdebug/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "83ee00f576d4aab396a812ee4c6e1f309dfd8543afd5f48897f706b8b548df2e"
  license "Apache-2.0"
  head "https://github.com/iximiuz/cdebug.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87510238d4c7394ad581e6b168a84c3b802768e092a5d65bd6cc3642f6ff9da6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d34ba9d19a4b8606c21c9238117ead651f80f97b7eac2e73fd4b04c0e2760502"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "daf1aeb531a7ba7188e81a0ad8d7b08fbac720cd3231878db7b1c6ad0bf331d0"
    sha256 cellar: :any_skip_relocation, ventura:        "d2412c3e0e57b4621badeaeeeb3fc30a909d1d45e74d6f5ffbf335a002926361"
    sha256 cellar: :any_skip_relocation, monterey:       "051da0dc3b6b4a0e2f306c90f008ff3cec7c22dd13f64bf66c68d21d7395a263"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a004605a5c7172873bf5851839932667b4811735eb94ee9062f847953cfd0b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90a92186ee6f2e14c8f660e7b90b8428d70b62d6ec3a41ed06ccf88c54d69098"
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
