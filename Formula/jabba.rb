class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  homepage "https://github.com/shyiko/jabba"
  url "https://github.com/shyiko/jabba/archive/0.9.6.tar.gz"
  sha256 "48122c4b2c7f14bd078d16cb66977acdcb441c5a9a3c4062b4102838106cb8fc"
  head "https://github.com/shyiko/jabba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "41910246c55a24183c94dc7da71aa93675393b5d07926679afe159d429419d00" => :high_sierra
    sha256 "0167b3f65ed2b8407b2b2a94c6f275936d5cbcc342efde19038238d40c9b24e7" => :sierra
    sha256 "e1e896039ff581ebf09ebc50c2da55b281021f54563517f1caaeb0a56b2debb3" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "glide" => :build

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
    system bin/"jabba", "install", "1.10"
    jdk_path = Utils.popen_read("#{bin}/jabba which 1.10").strip
    assert_match 'java version "10.0',
                 shell_output("#{jdk_path}/Contents/Home/bin/java -version 2>&1")
  end
end
