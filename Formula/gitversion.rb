class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.6.11.tar.gz"
  sha256 "019aa795201d249929a179464d7f45d4c7b62c11b39146efe58b135d27d507c0"
  license "MIT"

  bottle do
    sha256 cellar: :any, big_sur:  "225dc04b6f73fdcfca5cbfa1f4739e846903f202bc72eb4467876b90327d2465"
    sha256 cellar: :any, catalina: "4514224dccee7332547608f7319161703cc39c9ebd720bb613cccb7018152f17"
    sha256 cellar: :any, mojave:   "6b9fb13372bb96df48231e2ee33b88ac3a112bb78ffb45a23111ff358783eecf"
  end

  depends_on "dotnet"

  def install
    system "dotnet", "publish",
           "--configuration", "Release",
           "--framework", "net#{Formula["dotnet"].version.major_minor}",
           "--output", libexec,
           "src/GitVersion.App/GitVersion.App.csproj"

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
