class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.6.1.tar.gz"
  sha256 "4edcc8a78d4e2997a4a42accd5e8a72616be98d6f81ba302cef50538ded55846"
  license "MIT"

  bottle do
    cellar :any
    sha256 "d2e0670318e5758603341ec3975c40341b29405736b124388b05f4d990178449" => :big_sur
    sha256 "d0c2fca9d15e2d4c5eaf0154eb84c5db33e1b07ecee39564cfbb40340d4e976c" => :catalina
    sha256 "d0eb555c3ccc3d2c5334faee186a99c2f9547e3df3bad27b8fa6c93b1c52815c" => :mojave
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
