class Pillar < Formula
  desc "Manage migrations for Cassandra data stores"
  homepage "https://github.com/comeara/pillar"
  url "https://github.com/comeara/pillar/archive/v2.3.0.tar.gz"
  sha256 "f1bb1f2913b10529263b5cf738dd171b14aff70e97a3c9f654c6fb49c91ef16f"

  bottle do
    cellar :any_skip_relocation
    sha256 "99d50684a2a14939c7b651fb1483c5db1f49f3e979a9912a80d28cac3a59bc8c" => :sierra
    sha256 "0a9fca317e464bb8298c58bb21da39c93c7a128114f58a4ab3cd4f936efce46b" => :el_capitan
    sha256 "62c49f179045cc5a25190111ce406865f81cba454930b85912ba89ae8b59a2a0" => :yosemite
    sha256 "8c1ce70b45f766db666edffdc151c88e6b8c3a7cb4d7016d8aaf9e9466e1141b" => :mavericks
  end

  depends_on :java
  depends_on "sbt" => :build

  def install
    ENV.java_cache

    inreplace "src/main/bash/pillar" do |s|
      s.gsub! "$JAVA ", "`/usr/libexec/java_home`/bin/java "
      s.gsub! "${PILLAR_ROOT}/lib/pillar.jar", "#{libexec}/pillar-assembly-#{version}.jar"
      s.gsub! "${PILLAR_ROOT}/conf", "#{etc}/pillar-log4j.properties"
    end

    system "sbt", "assembly"

    bin.install "src/main/bash/pillar"
    etc.install "src/main/resources/pillar-log4j.properties"
    libexec.install "target/scala-2.10/pillar-assembly-#{version}.jar"
  end

  test do
    assert_match "Missing parameter", shell_output("#{bin}/pillar 2>&1", 1)
  end
end
