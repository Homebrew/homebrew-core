class Fvm < Formula
  desc "Manage Flutter SDK versions per project"
  homepage "https://fvm.app"
  url "https://github.com/leoafarias/fvm/archive/refs/tags/4.3.0.tar.gz"
  sha256 "2e235266a540387d8a7c54472256abc2429d0770738e344bac89e24fa89bbfa6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "254550e6fded53f94681480c42ab9f8edb442e429629f0d91f7a553096f8073e"
    sha256 cellar: :any,                 arm64_sequoia: "69831e970a5503948e7c0242c0e4c6c7eba0850a35b08661b5a0a2a1a9c37deb"
    sha256 cellar: :any,                 arm64_sonoma:  "693022704abb92bda486001fe4be417a62cc6b7e2a227f41bb253c96ebd6d140"
    sha256 cellar: :any,                 sonoma:        "044655a73bb1e619c2daa0bcc7ff32a02fe9cd302359147a9f4facce185c7278"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6aceee35cc7df23de2c183cd3f53eef25d038e12a268211732e2679089745d19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edcf4f11652ba84356a6750c4300ebfd201ab74c642c7fb4df46c92429a2746e"
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
