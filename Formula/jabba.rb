class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  homepage "https://github.com/shyiko/jabba"
  url "https://github.com/shyiko/jabba/archive/0.10.1.tar.gz"
  sha256 "059d5f14a23eba8f3cedf047c99489173fe52fe9bda6484e4000afc9cb7dfb0a"
  head "https://github.com/shyiko/jabba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7dde26490ae0f3d828c413bb2149abcf52f8c020cb0df33fb95b4bcf96842389" => :mojave
    sha256 "9da8b51ef97517e7f9db495a650bb8b41a330130e3a989221d00bbb4a81d30b5" => :high_sierra
    sha256 "e257449c7740e1fa33bd30f005804cda89b50a8df4401887eed3b4abcd98783d" => :sierra
    sha256 "3a8fbb3a2ac28a91ad50c1391b9f637a8877d89acc2eeabaa0ec79eb6a2bda2b" => :el_capitan
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
    system bin/"jabba", "install", "1.10"
    jdk_path = Utils.popen_read("#{bin}/jabba which 1.10").strip
    assert_match 'java version "10.0',
                 shell_output("#{jdk_path}/Contents/Home/bin/java -version 2>&1")
  end
end
