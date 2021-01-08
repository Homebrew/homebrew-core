class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.6.3.tar.gz"
  sha256 "f29ce37ed3cd6e8f81895c431fdb356de280807952986bcc54e3eefd3e054cda"
  license "MIT"

  bottle do
    cellar :any
    sha256 "386cb168c672cd51658af8a37559e788d8cd86d5529d2fd30fe2b8c19905b78c" => :big_sur
    sha256 "79ff7c600007f3b1c983f50d6621f890731b5f2179133033a48c28b98d73ea5a" => :catalina
    sha256 "0aa9e8d668a9cd3d1bd36c6fcd8372e3b2fc02e69e280b8a04dac59dea332cd8" => :mojave
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
    assert_match '"FullSemVer": "0.1.0+0"', shell_output("#{bin}/gitversion -output json")
  end
end
