class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net/docs/"
  url "https://github.com/GitTools/GitVersion/archive/refs/tags/6.8.2.tar.gz"
  sha256 "02b7efc0b9cfee26971c0f89b27724eb51d33c3230788963e77dc94070173c21"
  license "MIT"
  revision 1

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "53dd452592c6c061609ed3ebc09588213ad73e42d082aedb7745d6e529f27f61"
    sha256 cellar: :any, arm64_tahoe:       "67dc8435b985c3f4b81d60c87f61a4daad680471a453574c62b64f4243ffdaac"
    sha256 cellar: :any, arm64_sequoia:     "f983efd2abb47dd6ae67aafb15c0d45dc87852cf2a2dc3bc3b1a44abf7f76375"
    sha256 cellar: :any, arm64_linux:       "41ac3fea51b94565a08fa4f9ae6d4d10717ecad319efe979d69779731096c007"
    sha256 cellar: :any, x86_64_linux:      "d9a08ba35f4c80a141529f090071640dc1bb20525dbcd02149b4e371cc2b72f6"
  end

  depends_on "dotnet"
  depends_on "openssl@4"

  deny_network_access!

  def fetch
    # GitVersion uses a global.json file to pin the latest SDK version, which may not be available
    File.rename("global.json", "global.json.ignored")

    system "dotnet", "restore", "src/GitVersion.App/GitVersion.App.csproj", "--use-current-runtime"
  end

  def install
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-restore
      --no-self-contained
      --use-current-runtime
      -p:PublishSingleFile=true
      -p:Version=#{version}
    ]

    system "dotnet", "publish", "src/GitVersion.App/GitVersion.App.csproj", *args
    env = { DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}" }
    # Ensure OpenSSL is available for cryptography operations on Linux
    openssl = deps.find { |dep| dep.name.start_with?("openssl@") }
    env["LD_LIBRARY_PATH"] = "#{formula_opt_lib(openssl.name)}:${LD_LIBRARY_PATH}" if OS.linux?
    (bin/"gitversion").write_env_script libexec/"gitversion", env
  end

  test do
    # The sandbox denies FSEvents, so .NET's config file watcher would hang
    ENV["DOTNET_USE_POLLING_FILE_WATCHER"] = "1" if OS.mac?

    # Circumvent GitVersion's build server detection scheme:
    ENV["GITHUB_ACTIONS"] = nil
    # .NET named mutexes need `XDG_RUNTIME_DIR` (or `USER`) on Linux, which test containers may lack
    ENV["XDG_RUNTIME_DIR"] = testpath

    (testpath/"test.txt").write("test")
    system "git", "init"
    system "git", "config", "user.name", "Test"
    system "git", "config", "user.email", "test@example.com"
    system "git", "add", "test.txt"
    system "git", "commit", "-q", "--message='Test'"
    assert_match '"FullSemVer": "0.0.1-1"', shell_output("#{bin}/gitversion -output json")
  end
end
