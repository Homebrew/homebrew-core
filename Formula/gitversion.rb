class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.6.8.tar.gz"
  sha256 "56856b9cb49687f2f3e53d612a51138f7ab354b3e72eaef5690e63c79d1b8466"
  license "MIT"

  bottle do
    sha256 cellar: :any, big_sur:  "a0f78c6cfe556137a856bb22fdafd2a854dc25e313c6144f9fd22f90f7dd8a3f"
    sha256 cellar: :any, catalina: "1158a3d149592114f62361060f69077b91caad1b727d153f957657d3c1a7d641"
    sha256 cellar: :any, mojave:   "8e89caec762f6de9494f366847385f07d8402d03c700133f9454727a7948d332"
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
