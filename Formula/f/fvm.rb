class Fvm < Formula
  desc "Manage Flutter SDK versions per project"
  homepage "https://fvm.app"
  url "https://github.com/leoafarias/fvm/archive/refs/tags/4.1.2.tar.gz"
  sha256 "f3e77eb78459ae6917a2ac4d734360002e06072ea744d4e115afe1dc2cee1872"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3cc297fbb461505cf18d492e479cbbf43383f834fbea10efee02d6c32e738a31"
    sha256 cellar: :any,                 arm64_sequoia: "d0fa9c5c43e2619b06f524366513009e69387e538d590b968c442a1fb75d0f94"
    sha256 cellar: :any,                 arm64_sonoma:  "9680e4a82cce24734dec1a15bfa01b26981b23a9bbe853dd541d98d265564698"
    sha256 cellar: :any,                 sonoma:        "966795e37074216ea82b6c7d2c3555557ea39879540c8f0a0866a9f019fc3d8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2d773c82e15f715bad3ca6a633d94383a569d22b36d64796c3b1052315343e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "090ee3ff928f6c743d2f9818d5dc02f9916b1a1de0046916c3df10036b6f1e07"
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
