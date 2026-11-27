class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net/docs/"
  url "https://github.com/GitTools/GitVersion/archive/refs/tags/7.0.1.tar.gz"
  sha256 "a6b01ce3850e132760da786be07b8603eb1a1492ba0476dd243117cd5e472731"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    manifest_sha256 "50e2f6ec252c1eee34dcd9ada0abdf8db07f3e6f4ef1a40f0c45578c38501183"
    sha256 cellar: :any, arm64_golden_gate: "992f61fca409cb148c6ac95e02ea1c082e1285e870ae274d17da31cc638540ea"
    sha256 cellar: :any, arm64_tahoe:       "35d54be91f8f4363667456822404fa6f724919142e1ac51c6745703d63ea14c3"
    sha256 cellar: :any, arm64_sequoia:     "ac4ca570dc73cb0af8b79d5d8107a5166648f400e7c022da6580eb5d2cd66443"
    sha256 cellar: :any, arm64_linux:       "4659832468c62b09936c9f0957c504cd893db4266b36915180d024a6af6bc7a6"
    sha256 cellar: :any, x86_64_linux:      "0edfd4801cd3343a86cbd728e46c3868dd632db33913a17e657933af0ae6181a"
  end

  depends_on "dotnet"
  depends_on "openssl@4"

  deny_network_access!

  def dotnet = dep("dotnet").to_formula

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
    if OS.linux?
      openssl_lib = dep("openssl").opt_lib
      env["LD_LIBRARY_PATH"] = "#{openssl_lib}:${LD_LIBRARY_PATH}"
    end
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
