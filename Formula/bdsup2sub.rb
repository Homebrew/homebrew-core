class Bdsup2sub < Formula
  desc "Convert and tweak bitmap based subtitle streams"
  homepage "https://github.com/mjuhasz/BDSup2Sub"
  url "https://github.com/mjuhasz/BDSup2Sub/archive/5.1.2.tar.gz"
  sha256 "9441f1f842547a008c1878711cdc62c6656c0efea88e29bdfa6f21ac24ba87cd"

  depends_on "maven" => :build
  depends_on :java

  def install
    system "mvn", "clean", "package", "-Duser.home=#{buildpath}", "-DskipTests"
    libexec.install "target/BDSup2Sub-#{version}-jar-with-dependencies.jar"
    bin.write_jar_script(libexec/"BDSup2Sub-#{version}-jar-with-dependencies.jar", "BDSup2Sub")
  end

  test do
    assert_match(/^BDSup2Sub #{version}$/, shell_output("#{bin}/BDSup2Sub -V"))
  end
end
