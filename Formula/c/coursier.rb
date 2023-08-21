class Coursier < Formula
  desc "Pure Scala Artifact Fetching"
  homepage "https://get-coursier.io/"
  url "https://github.com/coursier/coursier/releases/download/v2.1.5/coursier.jar"
  sha256 "4bea0aad07d4cc45a96f04db2a2f32a9f98c8251e98043d0395a29cac3beba46"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-M\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "910f039790932a79aff886e658f1fadefbc2691d25ff09fec9c7912b9ebe77b8"
  end

  depends_on "openjdk"

  def install
    (libexec/"bin").install "coursier.jar"
    chmod 0755, libexec/"bin/coursier.jar"
    (bin/"coursier").write_env_script libexec/"bin/coursier.jar", Language::Java.overridable_java_home_env

    generate_completions_from_executable("bash", bin/"coursier", "completions", shells: [:bash, :zsh])
  end

  test do
    system bin/"coursier", "list"
    assert_match "scalafix", shell_output("#{bin}/coursier search scalafix")
  end
end
