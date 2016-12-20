class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-parent-262.tar.gz"
  version "20161219-262"
  sha256 "af1980edafa418d89d43f4f84dbc5bae75844760be21c48970a49938b0750ddc"

  bottle do
    cellar :any_skip_relocation
    sha256 "24bd62a0e38dec6a85b571bd15ea6361f6bb2894a1a73869c730a84a423defed" => :sierra
    sha256 "ddeded25dd387b274c9005138e5989d5386dda5a796268aaac293ae603c8b80d" => :el_capitan
    sha256 "a46bfaf3e3ab44e1e0b0c52cb2aa55f65370c105f56120479e99191b1074e28d" => :yosemite
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
