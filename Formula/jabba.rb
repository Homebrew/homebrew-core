class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  homepage "https://github.com/shyiko/jabba"
  url "https://github.com/shyiko/jabba/archive/0.9.2.tar.gz"
  sha256 "884da1fc23818db1396a8eeb4a10d40c7c008684b7642e2eec88bf264f47e071"
  head "https://github.com/shyiko/jabba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c73fba5030ff7426aab097addcea3266c66dcecfa602b223a4bacce87e262fc7" => :high_sierra
    sha256 "0335af2f2b4cf66b2478e7dccaaed8bba2e8b19c86d9910190fdee40b816e2e8" => :sierra
    sha256 "4b8814d66993e5d454c71f5370a4a2de5758b7d08e5f5a85eea68c10f4762b5e" => :el_capitan
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
