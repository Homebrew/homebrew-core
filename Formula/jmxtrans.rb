class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-parent-261.tar.gz"
  version "20161215-261"
  sha256 "460a035706baa738a5176a8e3664e487be2d49bcc11dacb1bada680b587034ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1cfdf6f91f4a608aac3f49015e624a7cca215bc5d626f1b7ae927dae7ca5c5c" => :sierra
    sha256 "da6cf23162aff7e739cd60417b9c97b3e2458d43ace426ff51d0b539c3f804f3" => :el_capitan
    sha256 "92395fe77f636e7c11f91cafbd2a180244dbe134821ae30ebbd66cc326b9a126" => :yosemite
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
