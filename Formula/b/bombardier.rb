class Bombardier < Formula
  desc "Cross-platform HTTP benchmarking tool"
  homepage "https://github.com/codesenberg/bombardier"
  url "https://github.com/codesenberg/bombardier/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "472b14b1c3be26a5f6254f6b7c24f86c9b756544baa5ca28cbfad06aacf7f4ac"
  license "MIT"
  head "https://github.com/codesenberg/bombardier.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b978ad033988b894ab8f8010b68e50cf7a3485ac575e7d1e4a0118913a400e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9485c29e3e9dadce928f167deea422c02238f212e5cf46b51de4e3298e25b2ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9485c29e3e9dadce928f167deea422c02238f212e5cf46b51de4e3298e25b2ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9485c29e3e9dadce928f167deea422c02238f212e5cf46b51de4e3298e25b2ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb82f62d4fc9f0766effee00a2b90e8a1e4a05e06244598d1652c4cd8241d051"
    sha256 cellar: :any_skip_relocation, ventura:       "fb82f62d4fc9f0766effee00a2b90e8a1e4a05e06244598d1652c4cd8241d051"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1edb1ce74da03b755bb33b3c1c9c701bfc8b87a93f39e520d0212b27a1485e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bcdfdcc9bfb6f81117fce7d1d7d169823c5b7bf15367af83ffdde9041953e9d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bombardier --version 2>&1")

    url = "https://example.com"
    output = shell_output("#{bin}/bombardier -c 1 -n 1 #{url}")
    assert_match "Bombarding #{url} with 1 request(s) using 1 connection(s)", output
  end
end
