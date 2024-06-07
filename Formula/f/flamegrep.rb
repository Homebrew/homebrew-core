class Flamegrep < Formula
  desc "Concurrent file search tool in Java"
  homepage "https://github.com/ABHIGYAN-MOHANTA/flamegrep"
  url "https://github.com/ABHIGYAN-MOHANTA/flamegrep/releases/download/init/flamegrep.jar"
  sha256 "a971329168ff0cc85e5199eb148fe0d144124f8b53c289b4149dce69ade26471"
  version "1.0.0"

  depends_on "openjdk"

  def install
    libexec.install "flamegrep.jar"
    bin.write_jar_script libexec/"flamegrep.jar", "flamegrep"
  end
end
