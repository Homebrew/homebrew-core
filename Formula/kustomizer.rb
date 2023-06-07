class Kustomizer < Formula
  desc "Package manager for distributing Kubernetes configuration as OCI artifacts"
  homepage "https://github.com/stefanprodan/kustomizer"
  url "https://github.com/stefanprodan/kustomizer/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "bba48e2eed5b84111c39b34d9892ffc9f0575b6f6470d50f832f47ff6417bf03"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/kustomizer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ba254b8051b47aa5f1fb36236027a7ba73cda8218c504b43065ab3ad7677584"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc06563ebe12218833949dd690e7c3ffbe71d815e16581657ba4971af6ad1a64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34ca6d21c6761b9732b0bd0cbb3bdc7bfa8c0701ba7edf2bd236f820be1ef44b"
    sha256 cellar: :any_skip_relocation, ventura:        "417bce8bb8cb178b6fcc5386ecbf4a01405253abfca33c036a03f99058ce9dd7"
    sha256 cellar: :any_skip_relocation, monterey:       "826930275079d88859fd26976d3e7d8d7e9ebf57edeae256e232ce4c3603ce2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f9ac16b04e1da34901f680da8c8f481e605d374822cf77752d68777f9cd9cf1"
    sha256 cellar: :any_skip_relocation, catalina:       "e954a47cd5a1e00b299a62432ec532ddd4545a7c2de6c4d669e2242af9080eb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ed1242aaec95d97b1c835476b50556d96a6f8902d1bcdeca14fa7625243b437"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}"), "./cmd/kustomizer"

    generate_completions_from_executable(bin/"kustomizer", "completion")
  end

  test do
    system bin/"kustomizer", "config", "init"
    assert_match "apiVersion: kustomizer.dev/v1", (testpath/".kustomizer/config").read

    output = shell_output("#{bin}/kustomizer list artifact 2>&1", 1)
    assert_match "you must specify an artifact repository e.g. 'oci://docker.io/user/repo'", output
  end
end
