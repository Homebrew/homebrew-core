class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.6.6.tar.gz"
  sha256 "36aa1bc58997a31d5c78ab98faaa8f3b4478a97b0caa3a6afeac6129ad279143"
  license "MIT"

  bottle do
    sha256 cellar: :any, big_sur:  "75ebeca8702ea549395c24070f1c376cb650663e549389c73c2e804d612b04e4"
    sha256 cellar: :any, catalina: "06b78e5440747da71e7e9b692cb09ed089c6e857dd9fbe7c510b6cbfd21e5883"
    sha256 cellar: :any, mojave:   "fb27d74a0ecd26af8792f43bb99ed6756486d61323382aee29f2248a18ef0527"
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
