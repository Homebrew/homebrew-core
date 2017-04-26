class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://github.com/int128/groovy-ssh"
  url "https://github.com/int128/groovy-ssh/archive/2.9.0.tar.gz"
  sha256 "9199c675b91041858a246eee156c6ed0d65d153efafb62820f66d3722b9d17bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "c8e18abd807d0ecce46b9541ee8f595633375e04aabc392478b17542db15a8b9" => :sierra
    sha256 "63dbeda42ab0d8d6af23d04b1485f868e8ee5b2f315c5538406c8da2901d8884" => :el_capitan
    sha256 "62ca0404e4429f62df84b96dba7b0219db9d883595f31a4427bd884a2e45b705" => :yosemite
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
