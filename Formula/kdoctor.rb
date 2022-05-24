class Kdoctor < Formula
  desc "Environment diagnostics for Kotlin Multiplatform Mobile app development"
  homepage "https://github.com/kotlin/kdoctor"
  url "https://github.com/Kotlin/kdoctor/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "cc972dfee89417c760eb845a0928cd99d3d7e4edf7d16ac5e43b5ea8425e1301"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kdoctor.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f5f58367195b2e6615ecf2f5e058383762e1960672deee009f1f4e99152c08b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "563f1aa5a78fca16dac048c7e1a14d54209cc25b80d3df8ebee7e49f0bc3423d"
    sha256 cellar: :any_skip_relocation, monterey:       "268c40758894f4acdc19a21586c4d1268ce5a407bfb291937fdf4dac3cf2a5ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "956ff7b276c22eb1828d049685858f0c3df23b287340ea04a052d54477dd74cb"
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
