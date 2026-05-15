class Kubectx < Formula
  desc "Tool that can switch between kubectl contexts easily and create aliases"
  homepage "https://github.com/ahmetb/kubectx"
  url "https://github.com/ahmetb/kubectx/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "1c8eb6b30c0067f89e5b2f9480865b0e3229a221fadddb644ce192d663c63907"
  license "Apache-2.0"
  head "https://github.com/ahmetb/kubectx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1b987001988e309fb4f479633dc4bdb7c212556853d89f9c33e44012230fead"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1b987001988e309fb4f479633dc4bdb7c212556853d89f9c33e44012230fead"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1b987001988e309fb4f479633dc4bdb7c212556853d89f9c33e44012230fead"
    sha256 cellar: :any_skip_relocation, sonoma:        "e29bc33ab632895925f7c730ce916f2dc09e6f1a0e65f244458601d59bd8340f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fda69a48f9d16e6a5325d8bb2a86b8f053ba0224c34d9f5683babfdcc3c977ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfe2732edeb88759e0283124e0ae89d8f73cad1e6c03644066074abbfd375f12"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectx"), "./cmd/kubectx"
    system "go", "build", *std_go_args(ldflags:, output: bin/"kubens"), "./cmd/kubens"

    ln_s bin/"kubectx", bin/"kubectl-ctx"
    ln_s bin/"kubens", bin/"kubectl-ns"

    %w[kubectx kubens].each do |cmd|
      bash_completion.install "completion/#{cmd}.bash" => cmd.to_s
      zsh_completion.install "completion/_#{cmd}.zsh" => "_#{cmd}"
      fish_completion.install "completion/#{cmd}.fish"
    end
  end

  test do
    assert_match "USAGE:", shell_output("#{bin}/kubectx -h 2>&1")
    assert_match "USAGE:", shell_output("#{bin}/kubens -h 2>&1")
    assert_match version.to_s, shell_output("#{bin}/kubectx -V")
    assert_match version.to_s, shell_output("#{bin}/kubens -V")
  end
end
