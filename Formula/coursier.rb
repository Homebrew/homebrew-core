class Coursier < Formula
  desc "Pure Scala Artifact Fetching"
  homepage "https://get-coursier.io/"
  url "https://github.com/coursier/coursier/releases/download/v2.1.0-M6/coursier.jar"
  version "2.1.0-M6"
  sha256 "68c4380b16f424047b48ac33c426fa2750f3424a9907e37fcf0c8b111081aa6a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-M\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0f2dbe77030f18fdb18afb0c111e7f9cbe8a619e728c035cbe66c3e3c4a9b5d0"
  end

  depends_on "openjdk"

  def install
    (libexec/"bin").install "coursier.jar"
    chmod 0755, libexec/"bin/coursier.jar"
    (bin/"coursier").write_env_script libexec/"bin/coursier.jar", Language::Java.overridable_java_home_env
  end

  test do
    system bin/"coursier", "list"
    assert_match "scalafix", shell_output("#{bin}/coursier search scalafix")
  end
end
