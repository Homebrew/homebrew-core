class Cozypkg < Formula
  desc "CLI for managing Cozystack packages"
  homepage "https://cozystack.io"
  url "https://github.com/cozystack/cozystack/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "c0cfe16962c2501fa6db3e6f4b925ecbd28263f55679246be46167345d1b82a1"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozystack.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fdf6ddaa767d82d1600dd37c4deab60ebc42cd9916c7b0bce2dc172ef44f3888"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b52f764462c07864ce3fde538c065799e8b4994ede1f4532b5541dc360fa203f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c0a0e494c5f528082e35bcb5df57fec56c362aad5c242f6bcb8ac0dd874e46e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "206e2f415054db4b1d33e04f841fa06bb11ce3f10a800521fe80eed2b08f61cb"
    sha256 cellar: :any,                 x86_64_linux:      "9a68147e2bc92ce1cf88486e483c35c2c82cb632c910a6f05b68c62f1cdb11b2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/cozystack/cozystack/cmd/cozypkg/cmd.Version=#{version}]
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
