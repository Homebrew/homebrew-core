class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.6.11.tar.gz"
  sha256 "019aa795201d249929a179464d7f45d4c7b62c11b39146efe58b135d27d507c0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 big_sur:      "40640f290fe8127679c87abcc704592eebaf0eae52ca55fc20cb5d5faa37c72d"
    sha256 cellar: :any,                 catalina:     "b004bbcba66e5dbf4dca5b66974e65f5b49e9a12b97724a91a2b029e0e4406f3"
    sha256 cellar: :any,                 mojave:       "85042a5e5f3791e1b07e9ee944c8a1217f3403836e7bac14793d1b37bb1fa906"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e7a37855fa2f2e65521a480b30c6037939118a1094938a84029b74f2dd239502"
  end

  depends_on arch: :x86_64 # dotnet does not support ARM
  depends_on "dotnet"

  def install
    os = "osx"
    on_linux do
      os = "linux"
    end

    system "dotnet", "publish", "src/GitVersion.App/GitVersion.App.csproj",
           "--configuration", "Release",
           "--framework", "net#{Formula["dotnet"].version.major_minor}",
           "--output", libexec,
           "--runtime", "#{os}-x64",
           "--self-contained", "false",
           "/p:PublishSingleFile=true"

    env = { DOTNET_ROOT: "${DOTNET_ROOT:-#{Formula["dotnet"].opt_libexec}}" }
    (bin/"gitversion").write_env_script libexec/"gitversion", env
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
