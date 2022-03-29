class Kdoctor < Formula
  desc "Environment diagnostics for Kotlin Multiplatform Mobile app development"
  homepage "https://github.com/kotlin/kdoctor"
  url "https://github.com/Kotlin/kdoctor/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "600ac57517ee5012b7eb23bad881cda1007bf7e8f916da36a86441fc4bff8dab"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kdoctor.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea987c7db59ea361a50681b7311a28ba3736957a8dbffe52593686903e747a7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea987c7db59ea361a50681b7311a28ba3736957a8dbffe52593686903e747a7f"
    sha256 cellar: :any_skip_relocation, monterey:       "d84364629903fae72979bffc6bdf89f31e6d766e6cf88ad9231cdd400f712834"
    sha256 cellar: :any_skip_relocation, big_sur:        "d84364629903fae72979bffc6bdf89f31e6d766e6cf88ad9231cdd400f712834"
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
