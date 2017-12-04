class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  homepage "https://github.com/shyiko/jabba"
  url "https://github.com/shyiko/jabba/archive/0.9.2.tar.gz"
  sha256 "884da1fc23818db1396a8eeb4a10d40c7c008684b7642e2eec88bf264f47e071"
  head "https://github.com/shyiko/jabba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c23d02756f7701a08fa4805bd6e6ae267fb51e3587b7e2748d267b76cfb7e06" => :high_sierra
    sha256 "1194d7753a570997667238c59ef05ca0c5f8c34029986b5cf7289fe48c656f15" => :sierra
    sha256 "177f97bc1d5da9cc38c187d75e213a292f7b526de424e095efcc8446225fdf14" => :el_capitan
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
    system bin/"jabba", "install", "1.9.0"
    jdk_path = Utils.popen_read("#{bin}/jabba which 1.9.0").strip
    assert_match 'java version "9.0.1"',
                 shell_output("#{jdk_path}/Contents/Home/bin/java -version 2>&1")
  end
end
