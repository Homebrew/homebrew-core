class Kdoctor < Formula
  desc "Environment diagnostics for Kotlin Multiplatform Mobile app development"
  homepage "https://github.com/kotlin/kdoctor"
  url "https://github.com/Kotlin/kdoctor/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "cc972dfee89417c760eb845a0928cd99d3d7e4edf7d16ac5e43b5ea8425e1301"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kdoctor.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc24bbbd334193ad52837e46c7e0724a25968d0e481970f5e2e127094aa0344d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6246e75bb09c13406a087261587cdd52fb0c46556ae7f7162cea336a950113a"
    sha256 cellar: :any_skip_relocation, monterey:       "41f6c721d8a7f721b825aca465ef2c41d6600d1f8a422bb018fb9cfc885a15bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "1da6a21f983709d788aa6cd2563669ab788a5cd9edc1b07dc3f4970177cde17d"
  end

  depends_on "gradle" => :build
  depends_on "openjdk" => :build
  depends_on xcode: ["12.5", :build]
  depends_on :macos

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    mac_suffix = Hardware::CPU.intel? ? "X64" : Hardware::CPU.arch.to_s.capitalize
    build_task = "linkReleaseExecutableMacos#{mac_suffix}"
    system "gradle", "clean", build_task
    bin.install "kdoctor/build/bin/macos#{mac_suffix}/releaseExecutable/kdoctor.kexe" => "kdoctor"
  end

  test do
    output = shell_output(bin/"kdoctor")
    assert_match "System", output
    assert_match "Java", output
    assert_match "Android Studio", output
    assert_match "Xcode", output
    assert_match "Cocoapods", output
  end
end
