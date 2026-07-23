class Cozypkg < Formula
  desc "CLI for managing Cozystack packages"
  homepage "https://cozystack.io"
  url "https://github.com/cozystack/cozystack/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "19837d90f37bde953bd80d3737be1d82379cc1f2d7aaa5d5a05c551ed7a70ccc"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozystack.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e849b34d36478928f8022803499fd9b8a851dd7872a12a83b96af75048c6836c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d093d67e3e548785e8c5fca2163140dc6d2bf08de44915218a06d9620657a3cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7925265d4ba68e49fdbf9240101dcee2a671f138dc9242bd0efff7fde25164ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e516002e58729a77ad523caa1b8581aa0af9c0589e378e3f38f640fbcb941ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27dbcd65bb5ba674fda89b33ae9cb22dca935cbc31775b9e8c491117430f7d98"
    sha256 cellar: :any,                 x86_64_linux:  "5d3132f5aaf43fb89c029dc087cf422abfb3cd7ab5c37145ca399d00d645280f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cozystack/cozystack/cmd/cozypkg/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cozypkg"
    generate_completions_from_executable(bin/"cozypkg", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cozypkg --version")

    ENV["KUBECONFIG"] = testpath/"nonexistent-kubeconfig"
    output = shell_output("#{bin}/cozypkg list 2>&1", 1)
    assert_match "failed to get kubeconfig", output
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
