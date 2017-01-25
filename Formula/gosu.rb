class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "http://gosu-lang.org/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.4.tar.gz"
  sha256 "1c7fcfe644ec715a67b1e5a4bf4d0549639c9b62fe3e6e67bfc9058c0a5f2b98"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "55f1dce8004ee791206118048ea9a6a0d2311561b6f063cf0803166b85536cb0" => :sierra
    sha256 "fd9496ee3c6fb407098f0bc0827e24206bb294fbc4b02937027c9a4a48b0966c" => :el_capitan
    sha256 "12e1c2dde23b52b7a2a12d090ef54f83c9f30bc5bba7b124fe64547e538ccbc4" => :yosemite
  end

  depends_on :java => "1.8+"
  depends_on "maven" => :build

  skip_clean "libexec/ext"

  def install
    ENV.java_cache

    system "mvn", "package"
    libexec.install Dir["gosu/target/gosu-#{version}-full/gosu-#{version}/*"]
    (libexec/"ext").mkpath
    bin.install_symlink libexec/"bin/gosu"
  end

  test do
    (testpath/"test.gsp").write 'print ("burp")'
    assert_equal "burp", shell_output("#{bin}/gosu test.gsp").chomp
  end
end
