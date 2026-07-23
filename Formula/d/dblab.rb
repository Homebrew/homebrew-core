class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "c793367242acda48c78cb5ed81f2b0ed8bc7df47cc134f30603061003f58fd98"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b7233510b076ac72d0ca1a64ed9e27dcdcdfd52a8f5c9beb92442dc3d7d4b55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "257edc657316f938c5df91c2b71dbe34f141a0822f130773587a4c038f76a4b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f202d3cafc5cdf8edf3f722bec06b8710df203629a4c7ab1b090fb471ad6477f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cc08ab1cf7d7b79db68be85b6330dd7987053387a27c100668aa00dcb441db4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c0ff8816ca859108c2a3c520187dd3363a589097026c86f2109a4f14fc9239b"
    sha256 cellar: :any,                 x86_64_linux:  "06609de960ec1d7291293b531070732bb28bff292fc12da938879d74a2ef99bd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
