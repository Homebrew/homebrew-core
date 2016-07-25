class Pillar < Formula
  desc "Manage migrations for Cassandra data stores"
  homepage "https://github.com/comeara/pillar"
  url "https://github.com/comeara/pillar/archive/v2.1.1.tar.gz"
  sha256 "5ed988911ae1e0d72531fec9a8834c4350879e68810a9703733ab650f19e77f8"

  bottle do
    cellar :any_skip_relocation
    sha256 "1515564663541917b83a77cad63a8e85d129295c58fe6e94a4dad8084e17182a" => :el_capitan
    sha256 "bfc2ef8aa748e93e40d3cdcb10bc5bdc8528de93692594c0a4414855e97ebde6" => :yosemite
    sha256 "ce43d94788d256a37410dd2b8b8635e57f0bedab12f681e99a2dd369d65fa001" => :mavericks
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
