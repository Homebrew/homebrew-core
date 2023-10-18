class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://github.com/golang/vuln/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "973a94a499c19c90f76624f9fc22d8a15b68fbb9565d74d237d4fb524bddf4ec"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36b8c11539e3d158666a71ffdcd76535fa80b667e04821930e2753ddccb2f4a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6a720241f4a758ee3309f1532414d2b88f154f6c9807e59ab11dbdb38fa6f5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6b46be14b67dbc508f0f136e39123909c00e9614035201bc6807fdad29ae932"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75c0a31f6e9a8f123d4c4159decd0e94a055ec54b0e8b5ec93605ab7caee324b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d602c1d943d31817d54c8ab06e7c043d56c9ea230ff33228e99442ceb3ad20a3"
    sha256 cellar: :any_skip_relocation, ventura:        "1ab22586e166ab32b1ecc0248f9c5a1439071f17e5ff3c9298921df35ab190ec"
    sha256 cellar: :any_skip_relocation, monterey:       "d21319d3e527914e89fad558df01710699a02729755b6c73a1c07ddefabb80f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "67d00716304ad8c4c0cf101ab9e5d903ae34759e6d89a13195794b40a39b07af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ed56bb11027b4d2d220f453537434b73d3943c4d63348a6f51ccbb46bc6dac7"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/govulncheck"
  end

  test do
    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"
      (testpath/"brewtest/main.go").write <<~EOS
        package main

        func main() {}
      EOS

      output = shell_output("#{bin}/govulncheck ./...")
      assert_match "No vulnerabilities found.", output
    end
  end
end
