class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.14.5.tar.gz"
  sha256 "3f3c8b3e3cb783a354b08eb53656fa82ca83cfd1eb833f1fdc075a94627f02ff"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20e7c36a1a9669b5522afa938c309eff16db714977cddb51c83323bd6adea29a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20e7c36a1a9669b5522afa938c309eff16db714977cddb51c83323bd6adea29a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20e7c36a1a9669b5522afa938c309eff16db714977cddb51c83323bd6adea29a"
    sha256 cellar: :any_skip_relocation, sonoma:        "667dedbf731c359e0a2594693bbf23c622c1730b95f4fbdce190487c26348bb7"
    sha256 cellar: :any_skip_relocation, ventura:       "667dedbf731c359e0a2594693bbf23c622c1730b95f4fbdce190487c26348bb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44958d90e65e758b8a61601286f0f6106f47d7f7f52b0ddc95e1f1460c8f41cd"
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
