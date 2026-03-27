require "json"

class Fvm < Formula
  desc "Manage Flutter SDK versions per project"
  homepage "https://fvm.app"
  url "https://github.com/leoafarias/fvm/archive/refs/tags/4.0.5.tar.gz"
  sha256 "2434d6fd2072548ac0e59c3c6c90554db46e6cdfd97ba79ffbcd270a8eb24b44"
  license "MIT"

  depends_on "dart-sdk"

  def install
    dart = Formula["dart-sdk"].opt_bin/"dart"

    ENV["PUB_ENVIRONMENT"] = "homebrew:fvm"
    ENV["PUB_CACHE"] = libexec/"pub_cache"
    ENV["DART_SUPPRESS_ANALYTICS"] = "true"

    system dart, "pub", "get"

    # Remove non-runtime example content from cached pub dependencies so the
    # keg does not retain platform-specific sample binaries.
    rm_r(Dir[libexec/"pub_cache/hosted/pub.dev/*/{example,examples}"])

    libexec.install "bin", "lib", "pubspec.yaml", "pubspec.lock", ".dart_tool"

    inreplace libexec/".dart_tool/package_config.json", libexec.realpath.to_s, opt_libexec.to_s

    rm bin/"fvm" if (bin/"fvm").exist?
    (bin/"fvm").write <<~SH
      #!/bin/bash
      export DART_SUPPRESS_ANALYTICS=true
      export PUB_ENVIRONMENT=homebrew:fvm
      exec "#{Formula["dart-sdk"].opt_bin}/dart" --packages="#{opt_libexec}/.dart_tool/package_config.json" "#{opt_libexec}/bin/main.dart" "$@"
    SH
    chmod 0555, bin/"fvm"
  end

  test do
    ENV["HOME"] = testpath

    output = shell_output("#{bin}/fvm api context --compress")
    context = JSON.parse(output).fetch("context")

    assert_equal version.to_s, context.fetch("fvmVersion")
    assert_equal testpath.to_s, context.fetch("workingDirectory")
    assert_predicate opt_libexec.glob("**/*.exe"), :empty?
  end
end
