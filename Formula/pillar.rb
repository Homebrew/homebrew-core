class Pillar < Formula
  desc "Manage migrations for Cassandra data stores"
  homepage "https://github.com/comeara/pillar"
  url "https://github.com/comeara/pillar/archive/v2.1.1.tar.gz"
  sha256 "5ed988911ae1e0d72531fec9a8834c4350879e68810a9703733ab650f19e77f8"

  bottle do
    cellar :any_skip_relocation
    sha256 "f43f0d6e71fcaac359da8499c4656f0971f11c5ceca687f77afa39518388b645" => :el_capitan
    sha256 "c6c6d24cedab121c9f3806fe0bb349dc0bcca776e4f86d3356a4871036584dc8" => :yosemite
    sha256 "43a15cddbbc537f00779ea82fa6ec648259535720ff5cc51bed38b028bb56b32" => :mavericks
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
