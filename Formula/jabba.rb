class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  homepage "https://github.com/Jabba-Team/jabba"
  url "https://github.com/Jabba-Team/jabba/archive/0.12.0.tar.gz"
  sha256 "15a142239869733d7f0fe8c0cc0cd99f619e5bc8121ebabc9c28c382333b89c0"
  license "Apache-2.0"
  head "https://github.com/Jabba-Team/jabba.git", branch: "main"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    dir = buildpath/"src/github.com/Jabba-Team/jabba"
    dir.install buildpath.children
    cd dir do
      ldflags = "-X main.version=#{version}"
      system "go", "build", "-ldflags", ldflags, "-o", bin/"jabba"
      prefix.install_metafiles
    end
  end

  test do
    jdk_version = "zulu@16.0-0"
    version_check ='openjdk version "16'

    ENV["JABBA_HOME"] = testpath/"jabba_home"

    system bin/"jabba", "install", jdk_version
    jdk_path = shell_output("#{bin}/jabba which #{jdk_version}").strip
    jdk_path += "/Contents/Home" if OS.mac?
    assert_match version_check,
                 shell_output("#{jdk_path}/bin/java -version 2>&1")
  end
end
