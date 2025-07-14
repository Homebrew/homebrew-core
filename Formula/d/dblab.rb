class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.danvergara.com/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "9a2d664cfe8ae553aa71598bcaecbaff0ce554ad05d9f0cbd4f18b3e941c2273"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "416e983fac3e039383f7950d42d1bdd84b12c2e669e5cd32e590fc1152857c12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "729de1720ba79ec58d9a0052dc9d9c0096b816804341a8570d34175fc95a9364"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a20a58eba3ec1581daa3bc42be7288cfab33c85143cfd4b2e9c0a6cd9e8b82ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "41f961dcecc418e50d7f744f9146c116954b5fa399f903760bbfb5a5caced7c0"
    sha256 cellar: :any_skip_relocation, ventura:       "7406d0b3781d164edbf0967e3acb211a17338df2d50bdbf6be37609ff18d1776"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91df82a06089aa027df282cdb2d8a83ba93c1333a6bb7f201c6f4f000f0098ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51f82c5141fe3a0456a4e2601aca1f9ad6e7310450a56541938c89ec1f1d6d58"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
