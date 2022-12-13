class Kdoctor < Formula
  desc "Environment diagnostics for Kotlin Multiplatform Mobile app development"
  homepage "https://github.com/kotlin/kdoctor"
  url "https://github.com/Kotlin/kdoctor/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "5d4e7800f312991ab8546f563b469ce2d4cdeb2b41ef6f4e66ab36bd4bb754d7"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kdoctor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "ce84bfa22bff49eb672ddc79f801f83d675601b55bacb7676fd3d0e0a4d6dff2"
    sha256 cellar: :any, arm64_monterey: "a288433059bf5a31544fa299f83859087f7b8f009008d1f91e105e9e1de80a94"
    sha256 cellar: :any, arm64_big_sur:  "b8b082f257bc98dd60957a84f93d5dbb498d602924970851a7a23dba736520e8"
    sha256 cellar: :any, ventura:        "63398f4fbccc67becfd7c5cbf3bee865b2c514d469f484d5c868afc0ecd4e461"
    sha256 cellar: :any, monterey:       "63398f4fbccc67becfd7c5cbf3bee865b2c514d469f484d5c868afc0ecd4e461"
    sha256 cellar: :any, big_sur:        "db47b398de4b9a38b434cb25e912cb6bc03490227f8c98816bbc29dc0896ac8b"
  end

  depends_on "gradle" => :build
  depends_on "openjdk" => :build
  depends_on xcode: ["12.5", :build]
  depends_on "curl"
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
