class KotlinToolchain < Formula
  desc "Build tool for Kotlin applications"
  homepage "https://kotlin-toolchain.org/"
  url "https://packages.jetbrains.team/maven/p/amper/amper/org/jetbrains/kotlin/kotlin-cli/0.13.0/kotlin-cli-0.13.0-dist.tgz"
  sha256 "fa82b9872dcfa04d26c8f800f33d597c99fbffd747a0e9bbce3a9e4424b3a588"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/JetBrains/kotlin-toolchain.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "openjdk"

  conflicts_with "kotlin", because: "both install a `kotlin` executable"

  deny_network_access!

  def install
    rm Dir["bin/*.exe"]
    chmod 0755, "bin/launcher.sh"
    libexec.install Dir["*"]
    (libexec/".flag").write stable.checksum.to_s
    (bin/"kotlin").write_env_script libexec/"bin/launcher.sh",
      KOTLIN_CLI_JAVA_HOME: formula_opt_prefix("openjdk")
    generate_completions_from_executable(bin/"kotlin", "generate-completion")
  end

  test do
    system bin/"kotlin", "init", "--from-template=jvm-cli", "--no-git"
    assert_path_exists testpath/"kotlin"
    assert_path_exists testpath/"kotlin.bat"
    assert_match stable.checksum.to_s, (testpath/"kotlin").read
    output = shell_output("#{bin}/kotlin show modules 2>&1")
    assert_match testpath.basename.to_s, output
  end
end
