class Fvm < Formula
  desc "Manage Flutter SDK versions per project"
  homepage "https://fvm.app"
  url "https://github.com/leoafarias/fvm/archive/refs/tags/4.3.2.tar.gz"
  sha256 "e16b1e76eb4df5b22d00ab40fe77cfd8c261be6f968e94eb081ad39af5615059"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "61449e6d995559059dc4b12d2da037d3ce7d709e3dc300f1d0c099ede7e797d3"
    sha256 cellar: :any,                 arm64_tahoe:       "89b653f484507d2e86e8feb860977708dcfd2fcf7e6826d71166813d9767fcda"
    sha256 cellar: :any,                 arm64_sequoia:     "bf5d78483abf1d0284afdb602c16dcdff0ca60f77f98ffc0cde856e68ca087f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "db5e871557ba7e037f70779230cd4dd54569755c859644c1678ce8d6350a6237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "457bab104a9c5e0bc7fab0fbcb6f523e7c6873ed924d978bc47f7134aeed76c6"
  end

  depends_on "dart-sdk" => :build
  depends_on "dartaotruntime"

  def install
    ENV["PUB_ENVIRONMENT"] = "homebrew:fvm"
    ENV["DART_SUPPRESS_ANALYTICS"] = "true"

    system "dart", "pub", "get"
    system "dart", "compile", "aot-snapshot", "--output", "fvm.aot", "bin/main.dart"
    libexec.install "fvm.aot"

    (bin/"fvm").write <<~BASH
      #!/bin/bash
      exec "#{formula_opt_bin("dartaotruntime")}/dartaotruntime" "#{libexec}/fvm.aot" "$@"
    BASH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fvm --version")

    output = shell_output("#{bin}/fvm api context --compress")
    context = JSON.parse(output).fetch("context")
    assert_equal version.to_s, context.fetch("fvmVersion")
    assert_equal testpath.to_s, context.fetch("workingDirectory")

    assert_match "No SDKs have been installed yet.", shell_output("#{bin}/fvm list")
  end
end
