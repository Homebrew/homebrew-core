class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  homepage "https://github.com/shyiko/jabba"
  url "https://github.com/shyiko/jabba/archive/0.11.2.tar.gz"
  sha256 "33874c81387f03fe1a27c64cb6fb585a458c1a2c1548b4b86694da5f81164355"
  head "https://github.com/shyiko/jabba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "799e49b05be61ad06b14ee0a8837242075e6eef8b7c8e045e94fde66894ce498" => :mojave
    sha256 "65ff5c790dcb3d072da11b5a550c15fc4baff76073187301d4d36e0278b32768" => :high_sierra
    sha256 "ea906d160c1214d58854b92c26c17ae761f2f308cb51090c94bbcb6b600263ca" => :sierra
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
