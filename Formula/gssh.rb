class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://github.com/int128/groovy-ssh"
  url "https://github.com/int128/groovy-ssh/archive/2.10.1.tar.gz"
  sha256 "d1a6e2293e4f23f3245ede7d473a08d4fb6019bf18efbef1a74c894d5c50d6a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "e62b8a6ca01051f9c49cf3031349c3460d1f1c4f32b6950d8cc7fc00b5ba4011" => :catalina
    sha256 "81d9d04f30ae5f158b18a3749f4e655d25374bc069292e22b47e5c0250ccea3d" => :mojave
    sha256 "4d9d09ec57af0639e794cbed732c12050fca8fe3d43d6e5d3e1de0e473eb5b0a" => :high_sierra
    sha256 "ef0becf43b6bfe4a1c1a3cffc27c5c01f338348273f66c7f4e3355e05f55b508" => :sierra
  end

  depends_on :java => "1.8"

  def install
    ENV["CIRCLE_TAG"] = version
    system "./gradlew", "shadowJar"
    libexec.install "cli/build/libs/gssh.jar"
    bin.write_jar_script libexec/"gssh.jar", "gssh", :java_version => "1.8"
  end

  test do
    system bin/"gssh"
  end
end
