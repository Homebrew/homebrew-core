class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net/docs/"
  url "https://github.com/GitTools/GitVersion/archive/refs/tags/6.8.2.tar.gz"
  sha256 "02b7efc0b9cfee26971c0f89b27724eb51d33c3230788963e77dc94070173c21"
  license "MIT"
  revision 2

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b353a708491ea11f18d320492dea6abb397980416311ca5f93269fe4171a2f39"
    sha256 cellar: :any, arm64_tahoe:       "b4b4f16cccdfd11606e0397be312d4396618de8f6ae4ebe1523b3fdf8940a1b2"
    sha256 cellar: :any, arm64_sequoia:     "181b7a089993b5fbf726a8e99460ca158ed210f0032f35b34c3303296782e045"
    sha256 cellar: :any, arm64_linux:       "bbfbe387f180e2e92456e9e3026a52e1fe2e31161dc5e060b2af6d0378fd44fb"
    sha256 cellar: :any, x86_64_linux:      "621b08d9d2775cd360015800c045e0b794f68ed2eaef453142bae08ffb5142d1"
  end

  depends_on "dotnet@10"
  depends_on "openssl@4"

  deny_network_access!

  def dotnet = deps.find { |d| d.name.match?(/^dotnet(@\d+)?$/) }.to_formula

  def fetch
    ENV["XDG_RUNTIME_DIR"] = buildpath
    # GitVersion uses a global.json file to pin the latest SDK version, which may not be available
    File.rename("global.json", "global.json.ignored")

    system "dotnet", "restore", "src/GitVersion.App/GitVersion.App.csproj", "--use-current-runtime"
  end

  def install
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"
    ENV["XDG_RUNTIME_DIR"] = buildpath

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
