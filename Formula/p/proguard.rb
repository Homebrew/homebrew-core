class Proguard < Formula
  desc "Java class file shrinker, optimizer, and obfuscator"
  homepage "https://www.guardsquare.com/en/products/proguard"
  url "https://github.com/Guardsquare/proguard/releases/download/v7.5/proguard-7.5.0.tar.gz"
  sha256 "48b1d6bd104acc12c9218250e88b3422815c86510cdd3c8c572a0386ac289376"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9901a1287ebb9c15aa55af90700bf075e568bc914c809924f0b4c9f330799a5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9901a1287ebb9c15aa55af90700bf075e568bc914c809924f0b4c9f330799a5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9901a1287ebb9c15aa55af90700bf075e568bc914c809924f0b4c9f330799a5c"
    sha256 cellar: :any_skip_relocation, sonoma:         "9901a1287ebb9c15aa55af90700bf075e568bc914c809924f0b4c9f330799a5c"
    sha256 cellar: :any_skip_relocation, ventura:        "9901a1287ebb9c15aa55af90700bf075e568bc914c809924f0b4c9f330799a5c"
    sha256 cellar: :any_skip_relocation, monterey:       "9901a1287ebb9c15aa55af90700bf075e568bc914c809924f0b4c9f330799a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b1046e12fc3e809bf98b015308135473795c43682d488b8c42e87d8af45e4f3"
  end

  depends_on "openjdk"

  def install
    libexec.install "lib/proguard.jar"
    libexec.install "lib/proguardgui.jar"
    libexec.install "lib/retrace.jar"
    bin.write_jar_script libexec/"proguard.jar", "proguard"
    bin.write_jar_script libexec/"proguardgui.jar", "proguardgui"
    bin.write_jar_script libexec/"retrace.jar", "retrace"
  end

  test do
    expect = <<~EOS
      ProGuard, version #{version}
      Usage: java proguard.ProGuard [options ...]
    EOS
    assert_equal expect, shell_output(bin/"proguard", 1)

    expect = <<~EOS
      Picked up _JAVA_OPTIONS: #{ENV["_JAVA_OPTIONS"]}
      Usage: java proguard.retrace.ReTrace [-regex <regex>] [-allclassnames] [-verbose] <mapping_file> [<stacktrace_file>]
    EOS
    assert_match expect, pipe_output("#{bin}/retrace 2>&1")
  end
end
