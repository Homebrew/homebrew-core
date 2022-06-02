class Ktor < Formula
  desc "CLI tool that creates porjects with ktor framework setup"
  homepage "https://github.com/ktorio/ktor-cli"
  url "https://github.com/ktorio/ktor-cli/archive/refs/tags/0.0.1-tmp.tar.gz"
  sha256 "bdb311910a3afcebe3428aee6fd1ef8c19ac670d089f362a6fb89030c3edf873"
  license "Apache-2.0"

  depends_on "gradle" => :build
  depends_on xcode: :build
  # https://youtrack.jetbrains.com/issue/KTOR-4570/Support-ARM-target-in-Ktor-client-with-KotlinNative-and-Curl
  depends_on arch: :x86_64

  uses_from_macos "curl"
  uses_from_macos "unzip"

  on_linux do
    depends_on "curl"
  end

  def install
    os_name = OS.mac? ? "macosX64" : "linuxX64"

    system "gradle", "linkReleaseExecutable#{os_name.capitalize}"
    bin.install "build/bin/#{os_name}/releaseExecutable/ktor-cli-generator.kexe" => "ktor"
  end

  test do
    system "ktor", "generate", "projectName"
    assert_predicate Pathname.new("projectName/build.gradle.kts"), :exist?
    assert_predicate Pathname.new("projectName/src/main/kotlin/com/example/Application.kt"), :exist?
  end
end
