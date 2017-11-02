class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  homepage "https://github.com/shyiko/jabba"
  url "https://github.com/shyiko/jabba/archive/0.9.1.tar.gz"
  sha256 "5e00ceec91afdea5ef2f2b5ffc764e552bb9837c1d69d7e1375136da46b15abd"
  head "https://github.com/shyiko/jabba.git"

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
    system bin/"jabba", "install", "1.9.0"
    jdk_path = Utils.popen_read("#{bin}/jabba which 1.9.0").strip
    assert_match 'java version "9.0.1"',
                 shell_output("#{jdk_path}/Contents/Home/bin/java -version 2>&1")
  end
end
