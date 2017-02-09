class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://github.com/int128/groovy-ssh"
  url "https://github.com/int128/groovy-ssh/archive/2.8.0.tar.gz"
  sha256 "d283bb2d42ffad64fc4b6bcaa4c6e0fa3641a672e9b52584149389a6aeed7241"

  bottle do
    cellar :any_skip_relocation
    sha256 "b146ce386e5a2e133cc3653b8b19a1addee6242db6de5247c7c2bcea9f7316fd" => :sierra
    sha256 "5dd52f5b1af8b3dff3792956856aa45f2a9b71ba936348b2e1dfc0f7034c34e0" => :el_capitan
    sha256 "e490aa7d90f0e629ffef7b77b6a55e1439f50002e1cafa940c4c679d619d6d6e" => :yosemite
  end

  depends_on :java => "1.7+"

  def install
    ENV.java_cache
    ENV["CIRCLE_TAG"] = version
    system "./gradlew", "shadowJar"
    libexec.install "cli/build/libs/gssh.jar"
    bin.write_jar_script libexec/"gssh.jar", "gssh"
  end

  test do
    system bin/"gssh"
  end
end
