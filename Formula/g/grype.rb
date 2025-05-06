class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.91.2.tar.gz"
  sha256 "0e7e43f84dac6ec63b7c75a3bc9e027255344860a7b70b8e2c6522e4e900062e"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf446f4f8a2a9ab9feea85c79d7a12d6a632cc8558feabbfd4b72493cda054c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a87e9b0aa7666018b48a420df3980ec1a0b6a898219e95c7e8f163d80f1b1891"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53aa4b8673e853b8aceeeabb25e0fb02714b98ebf0ce1dbd7805903b7a2e589e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa936e19f13e2ec2df40f8032acfab94b7f2651d74bf32a958ef0341f91b93a6"
    sha256 cellar: :any_skip_relocation, ventura:       "21f3cbbe82973a19254704b0fdebd092a16b0611acdc2144bfd1f31f050b8a22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08cf3e45190a035a16ee4215ed82d1bc53247a9c460e70cad10d288b0f05017b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adda1b23bda9085d6ec737cffdb1ec740e7ab01468e4ae0deaf5c8dd429343ca"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end
