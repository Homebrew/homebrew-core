class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.6.0.tar.gz"
  sha256 "256f65db9ec6476f6a430a9038ee3951b2d108bb84cbc34bd652bb53cc84a636"
  license "MIT"

  bottle do
    cellar :any
    sha256 "902c15e068c707f92083405d1bff5dc664ba4e77e944ca043c133220590dcf31" => :big_sur
    sha256 "6b2c74883286d8f515df9dc97fcb5342a9e720fee675e0947b1184110a7ce24e" => :catalina
    sha256 "8fc7140f2c3ae4a8828a7da95a4a0af5149d8156025b41ad2889f6ac2d71061e" => :mojave
  end

  depends_on "dotnet"

  def install
    system "dotnet", "build",
           "--configuration", "Release",
           "--framework", "netcoreapp3.1",
           "--output", "out",
           "src/GitVersionExe/GitVersionExe.csproj"

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
    assert_match '"FullSemVer":"0.1.0+0"', shell_output("#{bin}/gitversion -output json")
  end
end
