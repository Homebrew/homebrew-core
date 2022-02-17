class Kdoctor < Formula
  desc "Environment diagnostics for Kotlin Multiplatform Mobile app development"
  homepage "https://github.com/kotlin/kdoctor"
  url "https://github.com/Kotlin/kdoctor/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "e95af8f76fb3a6240758af76b5528e57b41793065354c81bff2fbebe435f22df"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kdoctor.git", branch: "master"

  depends_on "gradle"
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    mac_suffix = Hardware::CPU.intel? ? "X64" : Hardware::CPU.arch.to_s.capitalize
    build_task = "linkReleaseExecutableMacos#{mac_suffix}"
    system "gradle", "clean", build_task
    bin.install "kdoctor/build/bin/macos#{mac_suffix}/releaseExecutable/kdoctor.kexe" => "kdoctor"
  end

  test do
    r = /(.|\n)*(System)(.|\n)*(Java)(.|\n)*(Android Studio)(.|\n)*(Xcode)(.|\n)*(Cocoapods)(.|\n)*/
    assert_match r, shell_output("#{bin}/kdoctor")
  end
end
