class Pillar < Formula
  desc "Manage migrations for Cassandra data stores"
  homepage "https://github.com/comeara/pillar"
  url "https://github.com/comeara/pillar/archive/v2.3.0.tar.gz"
  sha256 "f1bb1f2913b10529263b5cf738dd171b14aff70e97a3c9f654c6fb49c91ef16f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f75ff57f647c404dbc95a7dc00330a5c9304d380437b7fd370795a1651fc3f7a" => :mojave
    sha256 "821dac9ddc56019fb7542a7ea77b33e6d3985a483a7f4d52482081389864d276" => :high_sierra
    sha256 "c84c1441dace68a35a68d280a3880ac4a62721480652474241b8d6a6b175742a" => :sierra
    sha256 "1f2264e263268d479e04a584003127c833eec237a3514c607f7d8090de48084c" => :el_capitan
  end

  depends_on "sbt" => :build
  depends_on :java => "1.8"

  def install
    inreplace "src/main/bash/pillar" do |s|
      s.gsub! "$JAVA ", "`/usr/libexec/java_home --version 1.8`/bin/java "
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
