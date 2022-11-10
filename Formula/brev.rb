class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.160.tar.gz"
  sha256 "45a036009202bb1a71c4439895fe5db1553fe22c0b9f3ca8cb1cebfbc38fc454"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "766bed06f1b573fc54865f7e1a69f7c42e56318cb57e23a62fe9fb5820a9dd65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bc769734777c0837d908679f5a905a30c4f3b528af16324ae2b1c85ad17e500"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "adb26a14d89f0efd0bebd16c659b570c3c5f0d781d29abe56796aad517e82ff1"
    sha256 cellar: :any_skip_relocation, monterey:       "a8d0f51342637f0e51a4dbca5f65da488447417fd91b3ee4c7bba552f1a8498d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4324c786309e367f1c7c8a78d5f8dfd1eaeab6571e0e4de282eebc7cdacee19b"
    sha256 cellar: :any_skip_relocation, catalina:       "5382bd84a5f8ea8e04f033121bff681e9e844e930cefa7b993020e2788d36a87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0a376f5d6a8e44d167bbe1878e48c65bee315c1df694c08595b5009fe273b06"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks instead of inet.af/netstack/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
