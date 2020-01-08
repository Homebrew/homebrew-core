class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  homepage "https://github.com/shyiko/jabba"
  url "https://github.com/shyiko/jabba/archive/0.11.2.tar.gz"
  sha256 "33874c81387f03fe1a27c64cb6fb585a458c1a2c1548b4b86694da5f81164355"
  head "https://github.com/shyiko/jabba.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0774ce652abc4e4a0e57bc8f4bbad5ecdae16b86ce28be04711bc48bba488e3d" => :catalina
    sha256 "d3bcd841125639c3eb01e5cce60667c2f2c914d61a2f3f21d68e75ec10cf793c" => :mojave
    sha256 "5d99c5f42d31a63c0019dbb1b16460553c91136ebbf2000f85a299c8aa8d0c15" => :high_sierra
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/shyiko/jabba"
    dir.install buildpath.children
    cd dir do
      ldflags = "-X main.version=#{version}"
      system "glide", "install"
      system "go", "build", "-ldflags", ldflags, "-o", bin/"jabba"
      prefix.install_metafiles
    end
  end

  test do
    ENV["JABBA_HOME"] = testpath/"jabba_home"
    system bin/"jabba", "install", "1.13.0"
    jdk_path = Utils.popen_read("#{bin}/jabba which 1.13.0").strip
    assert_match 'java version "13.0',
                 shell_output("#{jdk_path}/Contents/Home/bin/java -version 2>&1")
  end
end
