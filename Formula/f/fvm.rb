class Fvm < Formula
  desc "Manage Flutter SDK versions per project"
  homepage "https://fvm.app"
  url "https://github.com/leoafarias/fvm/archive/refs/tags/4.3.2.tar.gz"
  sha256 "e16b1e76eb4df5b22d00ab40fe77cfd8c261be6f968e94eb081ad39af5615059"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "acc1cb12c8f68bcb0d1f2caad504ad2832c54ed4b5c8e6fbb535368338ba79f8"
    sha256 cellar: :any,                 arm64_tahoe:       "f0e1ea0d35ba13b3c6141f230517b834940b3258d98b35705d75828e8e0a47a5"
    sha256 cellar: :any,                 arm64_sequoia:     "e8ec99fab9b673f3e905cd9db4f86611bdd7ec8be0c3592e88ddb81734c7db70"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c1906d31a56ccad38da1d4e515f42ed0e230851d416c79f6b3f1e82ffc6b8a3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5ed195908c26322674e108382a95a0d8f96272f292f53b7cc78cb297bfd9cb35"
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
