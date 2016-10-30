class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-parent-259.tar.gz"
  version "20160706-259"
  sha256 "9a93c23e463cd6af152f4fb715a0ffc04b8fdb5617178d8fd4da3030bcca1d86"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6246d3fd3593dd46adca7f66346c9931f55b52f342fba58f243a0d080b59722" => :sierra
    sha256 "a41b37df947adff1a076e1066ca0b8847105f8f8d5ca13c1bed1dbc44aca636f" => :el_capitan
    sha256 "51624098720247a7a54a2a1023578cba4adbb7673c804bfbfbfe83124e37d51e" => :yosemite
    sha256 "c57be793f849944d5fdb0a98ca089dacc61afb9a99ab3e353ef67aa1ff605d9f" => :mavericks
  end

  depends_on :java => "1.6+"
  depends_on "maven" => :build

  def install
    ENV.java_cache

    system "mvn", "package", "-DskipTests=true",
                             "-Dmaven.javadoc.skip=true",
                             "-Dcobertura.skip=true"

    cd "jmxtrans" do
      inreplace "jmxtrans.sh", "lib/jmxtrans-all.jar",
                               libexec/"target/jmxtrans-259-all.jar"
      chmod 0755, "jmxtrans.sh"
      libexec.install %w[jmxtrans.sh target]
      pkgshare.install %w[bin example.json src tools vagrant]
      doc.install Dir["doc/*"]
    end

    bin.install_symlink libexec/"jmxtrans.sh" => "jmxtrans"
  end

  test do
    output = shell_output("#{bin}/jmxtrans status", 3).chomp
    assert_equal "jmxtrans is not running.", output
  end
end
