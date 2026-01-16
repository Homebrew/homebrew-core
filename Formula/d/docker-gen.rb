class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.16.1.tar.gz"
  sha256 "c35fcc972c68cb6feea6f2ca1437a3a2b104df138b2ccbec39659a277950306b"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dccb8c3d7506d77c4c0d0f89b86144f6312c06810f951f8f5fe6edf42bea6945"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dccb8c3d7506d77c4c0d0f89b86144f6312c06810f951f8f5fe6edf42bea6945"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dccb8c3d7506d77c4c0d0f89b86144f6312c06810f951f8f5fe6edf42bea6945"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcaa037f17e5cfd0de53ef1a10a28448a0850890e7ce81d72fd30e2c7d243b2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b204f3f4528b82efae3521d5fa05e5b49af75cc7b42ca4ee73969d5a6cce758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a21ac0f9a4a8079bba22eae8aa594d735431c493f299665c41de48dae1b08c4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
