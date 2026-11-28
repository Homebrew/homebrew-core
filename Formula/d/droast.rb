class Droast < Formula
  desc "Opinionated Dockerfile linter"
  homepage "https://ewry.net/droast-dockerfile-linter/"
  url "https://github.com/immanuwell/dockerfile-roast/archive/refs/tags/1.8.0.tar.gz"
  sha256 "25aee89c883d2a578c16e09760ab0a84246b4d6e8d7192e1e09212b21a11bc56"
  license "MIT"

  bottle do
    manifest_sha256 "bb187ea0c7702dd8e2377ec83821b47a4c354c686d20ac05419c0023cab58ed5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ed36578b651385b91f3f9a894d6e22f8ee819956a776f16cd110eee7897f5eea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9a1ff6ec35caf3d28c4566dc8fd47238138ee8507b2ec09764cafb2c8854b017"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a7d5477fa7ae537e01c8bb20eb6a244fdf36991207af1088fa9b21eab679eac"
    sha256 cellar: :any,                 arm64_linux:       "50bff3930171b6ca2a32f2ed5c1b2a79591141eebec966c46acc87d2b4cb9f93"
    sha256 cellar: :any,                 x86_64_linux:      "6abdc0700ebaf5586d474f0ee0a422071145ae81f13ba70e98ca370c127391a0"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"droast", "completion")
  end

  test do
    (testpath/"Dockerfile").write <<~DOCKERFILE
      FROM alpine:3
      ENTRYPOINT ["echo", "hi"]
      ENTRYPOINT ["echo", "bye"]
    DOCKERFILE
    output = shell_output("#{bin}/droast --no-roast --format compact #{testpath}/Dockerfile", 1)
    assert_match "DF039", output
  end
end
