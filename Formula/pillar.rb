class Pillar < Formula
  desc "Manage migrations for Cassandra data stores"
  homepage "https://github.com/comeara/pillar"
  url "https://github.com/comeara/pillar/archive/v2.3.0.tar.gz"
  sha256 "f1bb1f2913b10529263b5cf738dd171b14aff70e97a3c9f654c6fb49c91ef16f"
  license "MIT"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "4edab61108a48ddf41f90c46872bbced08a6fb600ed84b8faa2a270be2d4eea4" => :big_sur
    sha256 "8aac25711310b56913c1838c9d6b4ef72af78ade7b20ca0f5b8519805854e285" => :catalina
    sha256 "935f68b739a2d86174a045032b5606fffb8c1fa4f7ef74fd0aabc6608dfe068a" => :mojave
    sha256 "74bd2dde375b70f3a6ad14c7c55bc511d372998d4901daebd627f0ca5200c6bd" => :high_sierra
  end

  depends_on "sbt" => :build
  depends_on "openjdk@8"

  def install
    inreplace "src/main/bash/pillar" do |s|
      s.gsub! "$JAVA ", "#{Formula["openjdk@8"].bin}/java "
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
