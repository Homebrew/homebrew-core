class Fvm < Formula
  desc "Manage Flutter SDK versions per project"
  homepage "https://fvm.app"
  url "https://github.com/leoafarias/fvm/archive/refs/tags/4.1.0.tar.gz"
  sha256 "44f24d6bef61f78fef509415bc8974fcd60c5ffe937f9a4d9b17fe26c55670a2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b136a3ca2e6c6b52ac8a18b61435c219feff003939926d24f90aba239a5e3a00"
    sha256 cellar: :any,                 arm64_sequoia: "72c092b3c9635d25884e21b6a9c0f390651322b0ea13fa45192d46d806e8f54e"
    sha256 cellar: :any,                 arm64_sonoma:  "967420bd0a848a536209f474981d15bd8dc45692c7640ec85930f5d851f752a0"
    sha256 cellar: :any,                 sonoma:        "b8fe0f897c8c65131555d20e3e804ecf3d1786e315953f75174c2db6d4dc01c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c1b6591d53657867adaad6abf38ac7994b25f580c2a80a8d4e4e21900d9be07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f875db19eae96f1ff96674587a15dbb73e139bc0b3b8d99ebe8bf127926c320"
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
