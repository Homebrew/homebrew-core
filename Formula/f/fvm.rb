class Fvm < Formula
  desc "Manage Flutter SDK versions per project"
  homepage "https://fvm.app"
  url "https://github.com/leoafarias/fvm/archive/refs/tags/4.3.1.tar.gz"
  sha256 "08eeac980533f959582996a2f79b1093a61e0edf8a0975fba8414768e092db6e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ea97fc5863682025710d0876b2ff9f2cc3397c624ecc20d1e2ee07511df50f64"
    sha256 cellar: :any,                 arm64_sequoia: "6aef819a301bbaa689f480ad98984bde01711730ee0873039bf1de973d751d15"
    sha256 cellar: :any,                 arm64_sonoma:  "19ade28ea75331a562bb2f2006295b6b7359b9019a05d14c3e15c6e096b24f5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9e7ac1ebe9549a17e99db8b75d29eceaf5f1b5cbce681b7f4b1f34c36230dc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c38f41e38edb138574d084604aa6f8ec93691fbc9fb9a46dd601ce703efd645"
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
