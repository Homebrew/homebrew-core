class Bdsup2sub < Formula
  desc "Convert and tweak bitmap based subtitle streams"
  homepage "https://github.com/mjuhasz/BDSup2Sub"
  url "https://github.com/mjuhasz/BDSup2Sub/archive/5.1.2.tar.gz"
  sha256 "9441f1f842547a008c1878711cdc62c6656c0efea88e29bdfa6f21ac24ba87cd"

  bottle do
    cellar :any_skip_relocation
    sha256 "aecc7041ecd1c62b9c0137307900322626d14df9ed68a08c751c683852c84d22" => :sierra
    sha256 "f968df4ee2bc466db807253162b7355fc24ef58b2980c8f7a97f9adb88d8919a" => :el_capitan
    sha256 "3a18dd1e06ad18f5116e36677cf0644908295a637b9af8fc26e16ac28b2004a7" => :yosemite
  end

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
