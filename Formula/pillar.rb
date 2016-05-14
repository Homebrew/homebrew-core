class Pillar < Formula
  desc "Manage migrations for Cassandra data stores"
  homepage "https://github.com/comeara/pillar"
  url "https://github.com/comeara/pillar/archive/v2.0.1.tar.gz"
  sha256 "d5db7fbf956dae05794ec7b26c1de70aaab1d21fed774d95d16a241e9dd3952e"

  bottle do
    cellar :any_skip_relocation
    sha256 "15701b3bcfcfbded994680a3b923ea430e1e5618f2b2cb96a45a65c50b012d0f" => :el_capitan
    sha256 "6399b70e777a2067922a435c0bd71409d8c01dc3bb89618aa1859f1714a0dc2b" => :yosemite
    sha256 "366bd1d56bd750f7886ff97c5108831213361d996fcf1b6085dde53cd1638c37" => :mavericks
  end

  depends_on :java
  depends_on "sbt" => :build

  def install
    ENV.java_cache
    system "sbt", "assembly"

    inreplace "src/main/bash/pillar" do |s|
      s.gsub! "/usr/java/default", "`/usr/libexec/java_home`"
      s.gsub! "${PILLAR_ROOT}/lib/pillar.jar", "#{libexec}/pillar-assembly-#{version}.jar"
      s.gsub! "${PILLAR_ROOT}/conf", "#{etc}/pillar-log4j.properties"
    end

    bin.install "src/main/bash/pillar"
    etc.install "src/main/resources/pillar-log4j.properties"
    libexec.install "target/scala-2.10/pillar-assembly-#{version}.jar"
  end

  test do
    assert_match "Missing parameter", shell_output("#{bin}/pillar 2>&1", 1)
  end
end
