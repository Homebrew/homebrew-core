class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.0.6.tar.gz"
  sha256 "f62db72da69b4de60fdecaf7e597c401f1fa054cee5f0a178460a65b0e879a57"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d7f25caafec7079cc865ca0c411f5fd3c03c31ab750ac5f2826ac431ac8181b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8d2d2414050f49b12066f2fecad6227e97b69a4b46570e62d6f60fb328f2bc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d87b94297797476c4cfd0e31c9e35453f74037b2ce084e6d10aeddc42d658c90"
    sha256 cellar: :any_skip_relocation, sonoma:        "3824727dcf2192852080279aa5d264ede8a4f54d5d26028e2d5f22583128d5b9"
    sha256 cellar: :any_skip_relocation, ventura:       "ab7bd4519b44fa2dc7857d77241d67a1a95f56797e9dd6b4672e33bea10c5966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d52d004164f9b68d880b66f020dd0de1121dd4d04375155a83ea8d51cbc27fb1"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node@22" => :build # unpin after https://github.com/kubetail-org/kubetail/pull/139
  depends_on "pnpm" => :build

  def install
    system "make", "build"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output
  end
end
