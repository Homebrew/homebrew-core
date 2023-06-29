class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/v0.45.0.tar.gz"
  sha256 "5dfddddd1eaa53986b0d5cf2358f3d5918f656a86827d26d5605a159fe0536f8"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7d567897931223ce51102bdac60b848a790623e11fb73a139efa92a93432dd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb03b14c44fb6b1d1cf4c912ea3152871eff8d33cb9191a5dd8b5b7ba918054c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7d567897931223ce51102bdac60b848a790623e11fb73a139efa92a93432dd4"
    sha256 cellar: :any_skip_relocation, ventura:        "94024c7be655a9559bfb9f7211e9af2d45a33e5bbd6437bde6fecbf304d8fd3e"
    sha256 cellar: :any_skip_relocation, monterey:       "94024c7be655a9559bfb9f7211e9af2d45a33e5bbd6437bde6fecbf304d8fd3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ace05eb2da4809050610937fa16f1ad1b9504a788f657d5db5f0842097ea54c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5bcedeeb69c1f825a4a791bb0ca451ebf762966e6da40a660212f03dd667b89"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"k6", "completion")
  end

  test do
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
