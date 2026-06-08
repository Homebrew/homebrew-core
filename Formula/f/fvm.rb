class Fvm < Formula
  desc "Manage Flutter SDK versions per project"
  homepage "https://fvm.app"
  url "https://github.com/leoafarias/fvm/archive/refs/tags/4.1.0.tar.gz"
  sha256 "44f24d6bef61f78fef509415bc8974fcd60c5ffe937f9a4d9b17fe26c55670a2"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32523c511ab9669914a3568be186eca1fff5843758d269ec1c26104af01a0bb1"
    sha256 cellar: :any,                 arm64_sequoia: "4f385543134f5e6c094af586e4b580c341d9c8692921a7bc60c6b0da47eef357"
    sha256 cellar: :any,                 arm64_sonoma:  "39ded2651bfad704ce69aec3387846d3fb2ee9c4a95bedcd464c10b6d28b31c1"
    sha256 cellar: :any,                 sonoma:        "e9e6f677e7aff2711e0152f8575165dcfe7444cd2f0e9da8272f2e0aebf5a564"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ea2ee34061138d97d428393a6a07767ac087b97cab5703837cae7156f14b56c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33b6090416edb4ad3110d3f5e15145142ff6016b8f2dd897e47e890f12e293fa"
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
