class Gmailctl < Formula
  desc "Declarative configuration for Gmail filters"
  homepage "https://github.com/mbrt/gmailctl"
  url "https://github.com/mbrt/gmailctl/archive/v0.10.2.tar.gz"
  sha256 "e2f82a83dd8487b66142ba81783d5bf48f354e7bfbcac39ffff3b057d2121bb2"
  license "MIT"
  head "https://github.com/mbrt/gmailctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "606540a41a5a89806efc5746269205edc91cb420044d66a26a22d875f05498cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "865fce3ecf140b71055cad25ade4dbcea106231ac644f4520b2a1d7573ccba32"
    sha256 cellar: :any_skip_relocation, monterey:       "7bdfc9caa322cd5ba1953ed71d64b48d4b154aaa51790e0b6d1dce8b948f38e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "35e47da8c159a1a2324535a7a5e209f9f0b56553a3989ee3c8ecb5e7bfb2839a"
    sha256 cellar: :any_skip_relocation, catalina:       "5e061612d24ae1ca823efced64ac211adf0f773d7765d4eff319a9f735c07814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c710c62b45e0dbe92ab4ac41a2250851863512c3fac0bd4fe0eb0a76ee76f88"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "cmd/gmailctl/main.go"
  end

  test do
    assert_includes shell_output("#{bin}/gmailctl init --config #{testpath} 2>&1", 1),
      "The credentials are not initialized"

    assert_match version.to_s, shell_output("#{bin}/gmailctl version")
  end
end
