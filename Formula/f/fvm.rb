class Fvm < Formula
  desc "Manage Flutter SDK versions per project"
  homepage "https://fvm.app"
  url "https://github.com/leoafarias/fvm/archive/refs/tags/4.1.4.tar.gz"
  sha256 "d8c90f739bf023906ccc5f533bb403690351ef8d8285380f180fbc278be97536"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80613b71279baa81c1478e814dfebe4ec63bed64c7816242521c389adc6f49b3"
    sha256 cellar: :any,                 arm64_sequoia: "0c18dea92361efd54087454a54c615fc397e00a846bf1a84c49ed398e374cdbb"
    sha256 cellar: :any,                 arm64_sonoma:  "b4abd2a53c3512255b0ab76c9e3ed36886188438b4839d42cb3d1c94e0f329bb"
    sha256 cellar: :any,                 sonoma:        "b5e9d6a260b83b7f6f485fb1cda20884760d2856103867f88dab716c6b3b328a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3a5f433d2fd3424e48f47a8a9d2da36de1ea85d4b1f7115350bb49415edd2cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55f5daafccd69564551973529ad1e561ff80868546cf7dbf550987ffd5583c0c"
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
