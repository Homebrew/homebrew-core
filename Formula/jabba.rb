class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  homepage "https://github.com/shyiko/jabba"
  url "https://github.com/shyiko/jabba/archive/0.10.0.tar.gz"
  sha256 "da26cc60e33420e752a04251111ee23a582f2ea0196494b120811f66be56e369"
  head "https://github.com/shyiko/jabba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6446ba6aa275086fdba9a36f371280358cc2e6cbc0a0810099cdf17dcdbef70" => :high_sierra
    sha256 "eeb1854fcb1c94a2e3bc606807e31b862f41ffe389aad2ca16bd30b9aec2df31" => :sierra
    sha256 "2ed4ad3609b4c1005cca3ba81228fac15039f2a2b34b6abf08f74e59e0a07de5" => :el_capitan
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
