class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "8b808c73e7c8296a88ce25923b4a289870546139b09ac06d6400c42916e1217d"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55d24385f51664ae79abc4c35cd8087998bd6d087d37a603b0dd4f62c6bd7f3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55c6a017efc4096daf14339fb510953dce1404ff927374f30bff62ee46a36bb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11cfb7a93b8e0f056250fc578a1c43c38cf8dff713b120832fa7aa34a11282e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "bef65554986976de51dfb5cc6788358d977eafe79230b7ec88a1f758b2108d50"
    sha256 cellar: :any_skip_relocation, ventura:        "0d9be8ee042cffa7e37b73dc67d683941454da775a79d1d6d72605e50e3c77f3"
    sha256 cellar: :any_skip_relocation, monterey:       "1646d14297210b65d172f7d30c76133c801af45ba74640f86eaa797adeb4ca11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db9728532ab1e67b2934fc48d469b0ca97bb70e5660b9ec03e4fa0fa8a5c6af1"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/falcosecurity/falcoctl/cmd/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.buildDate=#{time.iso8601}
      -X #{pkg}.gitCommit=#{tap.user}
      -X #{pkg}.semVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"falcoctl", "completion")
  end

  test do
    system bin/"falcoctl", "tls", "install"
    assert_predicate testpath/"ca.crt", :exist?
    assert_predicate testpath/"client.crt", :exist?

    assert_match version.to_s, shell_output(bin/"falcoctl version")
  end
end
