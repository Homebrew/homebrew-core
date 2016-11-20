class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-parent-260.tar.gz"
  version "20161109-260"
  sha256 "a3d9eeaedf43da17ba79e7a9f541b53eb44b099c52ce893689c4419ff033f3c6"

  bottle do
    cellar :any_skip_relocation
    sha256 "49ea727b5641025400abd4d593fc5786a638d31e7021804e73d0275b063a7253" => :sierra
    sha256 "5b9757617ab30b3e53f0480faaa77bdc3e32bf92b7db182596b11eb792d24d7c" => :el_capitan
    sha256 "23e94a80bc4dc8953e9bcaa4ae9cde0af27b3a77d12203e841e923e8eff42f8b" => :yosemite
  end

  depends_on :java => "1.6+"
  depends_on "maven" => :build

  def install
    ENV.java_cache

    system "mvn", "package", "-DskipTests=true",
                             "-Dmaven.javadoc.skip=true",
                             "-Dcobertura.skip=true"

    cd "jmxtrans" do
      vers = Formula["jmxtrans"].version.to_s.split("-").last
      inreplace "jmxtrans.sh", "lib/jmxtrans-all.jar",
                               libexec/"target/jmxtrans-#{vers}-all.jar"
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
