class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.6.6.tar.gz"
  sha256 "36aa1bc58997a31d5c78ab98faaa8f3b4478a97b0caa3a6afeac6129ad279143"
  license "MIT"

  bottle do
    sha256 cellar: :any, big_sur:  "ab81351253a6c1f902f84021c5b5a7779b45997f99b670e93542ff76af6fb50c"
    sha256 cellar: :any, catalina: "ec5e34395f62fda57ac95fcc3d505c7d6dddcae0e98e505062a14ad207c431a0"
    sha256 cellar: :any, mojave:   "7f6423da50e61a68ef6861b7ba4beabe9e2e9fa97f84a16c79c90c534c048311"
  end

  depends_on "dotnet"

  def install
    system "dotnet", "build",
           "--configuration", "Release",
           "--framework", "net#{Formula["dotnet"].version.major_minor}",
           "--output", "out",
           "src/GitVersion.App/GitVersion.App.csproj"

    libexec.install Dir["out/*"]

    (bin/"gitversion").write <<~EOS
      #!/bin/sh
      exec "#{Formula["dotnet"].opt_bin}/dotnet" "#{libexec}/gitversion.dll" "$@"
    EOS
  end

  test do
    # Circumvent GitVersion's build server detection scheme:
    ENV["GITHUB_ACTIONS"] = nil

    (testpath/"test.txt").write("test")
    system "git", "init"
    system "git", "config", "user.name", "Test"
    system "git", "config", "user.email", "test@example.com"
    system "git", "add", "test.txt"
    system "git", "commit", "-q", "--message='Test'"
    assert_match '"FullSemVer": "0.1.0+0"', shell_output("#{bin}/gitversion -output json")
  end
end
