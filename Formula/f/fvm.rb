class Fvm < Formula
  desc "Manage Flutter SDK versions per project"
  homepage "https://fvm.app"
  url "https://github.com/leoafarias/fvm/archive/refs/tags/4.0.5.tar.gz"
  sha256 "2434d6fd2072548ac0e59c3c6c90554db46e6cdfd97ba79ffbcd270a8eb24b44"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ced2d7c1cdb6a8cfaaa34f5bdd85c19c7c1b6220d49d32aa2ba2ff624fda6fea"
    sha256 cellar: :any,                 arm64_sequoia: "a8d5965f58cdb96f12389a50cdcf753502f1e228a62e88316f8eb0f2ef3339dc"
    sha256 cellar: :any,                 arm64_sonoma:  "7978735939227cd4a1aafbdf737bfdc876a7742e4e24a78c114529aa6c290ad8"
    sha256 cellar: :any,                 sonoma:        "39c6e85efe13caca4af5cab3230d11ce8f41db35f3b269dfbfacc73b467658c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed9528de4e943980299fd605ad37563aad56f9378d1e77ab47ceb0524aafeed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b328245a99572faeb46d08a279d06b059bdc75b5ee76b63262371050ab552b10"
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
      exec "#{Formula["dartaotruntime"].opt_bin}/dartaotruntime" "#{libexec}/fvm.aot" "$@"
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
