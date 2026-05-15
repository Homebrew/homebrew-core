class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://docs.ignite.com/"
  url "https://github.com/ignite/cli/archive/refs/tags/v29.10.0.tar.gz"
  sha256 "9acb18354e9be72dd6e79c9b9cbfa3c8157061f55e354e59646f20b63aeb89f5"
  license "Apache-2.0"
  head "https://github.com/ignite/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d7cfa24fa703759099b5b3c6633450deed3948d4b7efb31fd537775a4f3a4b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9101f5e6bac265f4885eff791c30d37bb45140a170bcf96f7f1bfdbf926b560a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "749c2e63478fc580597e5d8996e8cc88db0e19bce6466cf0d195aab2be89faff"
    sha256 cellar: :any_skip_relocation, sonoma:        "a00f105cd465fd963829e3b91aca1e2e9d2d943a9f279e8be2f4831481c43764"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7515bfdf7f8e77019ff9b85c6176742086fe6bc46677b53fa289729cdb6a43e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "632260e5c804e7848ab43b114ca4afc67795083ea6102a0127884f53c4d32a1d"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin/"ignite"), "./ignite/cmd/ignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars", "--no-module", "--skip-proto"
    sleep 5
    sleep 10 if OS.mac? && Hardware::CPU.intel?
    assert_path_exists testpath/"mars/go.mod"
  end
end
