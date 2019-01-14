class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  homepage "https://github.com/shyiko/jabba"
  url "https://github.com/shyiko/jabba/archive/0.11.2.tar.gz"
  sha256 "33874c81387f03fe1a27c64cb6fb585a458c1a2c1548b4b86694da5f81164355"
  head "https://github.com/shyiko/jabba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4214658f6ce8d3e2f364ba5859278e6f32ed1dee5afe9f692103dd0d430e3205" => :mojave
    sha256 "fa50cc2c872c5e8241c986f1ee0237e549a51340d3896901076e5baee77ae6b7" => :high_sierra
    sha256 "65736798d127fbad2f048dada9e46399454e784bc009e266be55a328ea526010" => :sierra
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
    system bin/"jabba", "install", "1.11.0"
    jdk_path = Utils.popen_read("#{bin}/jabba which 1.11.0").strip
    assert_match 'java version "11.0',
                 shell_output("#{jdk_path}/Contents/Home/bin/java -version 2>&1")
  end
end
