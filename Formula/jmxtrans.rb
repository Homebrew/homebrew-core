class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-parent-267.tar.gz"
  sha256 "5898bcc02e45a5fbc7b38af7ba6788d8a85f55e54285a668848c2064138aa9ea"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "d18b73d89cb462d4343289fd57ac22c0aff14ee08e15d16728b868f9200917e5" => :sierra
    sha256 "0a1fec59601c7e7c9e4ced90193c1dcccee4c7a7e10ed7c647d3115f0afd54a2" => :el_capitan
    sha256 "9f3aa7d2469df6cfb27e52d66052693fd1b0a73732d3b10b16c08b788109dcb3" => :yosemite
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
