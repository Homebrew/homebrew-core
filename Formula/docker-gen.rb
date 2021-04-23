class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/jwilder/docker-gen"
  url "https://github.com/jwilder/docker-gen/archive/0.7.6.tar.gz"
  sha256 "6fa4aa083b21636250a0067f9365be8c739bd56f85fdbb612dbf37578be68d1f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3c85b99b9c196d88d88f1b841b945581dbf532a535d5ae9eddcba113186479c2"
    sha256 cellar: :any_skip_relocation, big_sur:       "a8e0c7dc323e6d12139778d740422435c4f7e8c5515ea1fe1b3020cbf570aefa"
    sha256 cellar: :any_skip_relocation, catalina:      "de774435b70a8ef725753d6f21c53059ff9702e40579eeca873b2bbd58d57e9f"
    sha256 cellar: :any_skip_relocation, mojave:        "f9fd70bd526ee9deedac3d51b76fc680ab9bd6ff0a15bec040ecec682c8ee000"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
