class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net/docs/"
  url "https://github.com/GitTools/GitVersion/archive/refs/tags/7.0.0.tar.gz"
  sha256 "3162799004cdf1187d80906e38c1761f796ad21cd935ea67597f5efc8b3e5a11"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cd4e57eb3fffe4bf0295008524a29b8b6ebedf51a7b2a05589b22944b2bd11f8"
    sha256 cellar: :any, arm64_tahoe:       "5496b0469bddaca7d8c9be24aeda230b219424ef20e3ae65af23923f33c939db"
    sha256 cellar: :any, arm64_sequoia:     "f38bbf3adcbf28e83fa3172319f62a3b3854e994f863c2808b520b580bb9fc9f"
    sha256 cellar: :any, arm64_linux:       "fd8d81c07e4e701708743e68d8a7e1b165932466a7ebda4bf3b313e1af2edf6a"
    sha256 cellar: :any, x86_64_linux:      "7604f10288bc1af927fdc2d707890767663a075bba0a39a60ab49326f5288c28"
  end

  depends_on "dotnet"
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
    assert_match '"FullSemVer": "0.0.1-1"', shell_output("#{bin}/gitversion --output json")
  end
end
