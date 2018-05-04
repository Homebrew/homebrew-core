class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  homepage "https://github.com/shyiko/jabba"
  url "https://github.com/shyiko/jabba/archive/0.9.4.tar.gz"
  sha256 "6c03151f0d4d224269bafb3a7655d92a8e19940a2fa8bf5a9bd78a28b71cd79d"
  head "https://github.com/shyiko/jabba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfb2b3e097be96dffa5dd14aab109317a3b80e7351b6fc2b481ba8c3618b34d0" => :high_sierra
    sha256 "1741877c9df2aae2350fe91ffe23ae30984996bd6e3a0ab09f608e5ea6b0c38e" => :sierra
    sha256 "34529d4bfd9dbf396596ddfae8b15c99a24cc5d92e73cdf4e82c6cee2c7ec97a" => :el_capitan
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
