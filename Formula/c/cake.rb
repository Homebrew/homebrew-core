class Cake < Formula
  desc "Cross platform build automation system with a C# DSL"
  homepage "https://cakebuild.net/"
  url "https://github.com/cake-build/cake/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "ea45d7a69f7bc373bd4d38ed708632a4ff7365d36cb9a85c40a107e6a7ae2c1b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be043f0290cd7508b8a1f72825935e6a100f37420e94b0bff157346c7bc7f7e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b05bd41b2a72ef0fedec5de35c41480cacb08b5053793ff1d14bd498ffaa4e7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3ffdc8ec23170142eb6a216296b0af43127a892c3cbb7625f8e1868395d6acd"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e5a760d11a3f3b3f7c1ced811373b923c2ef949f75885b726cdaae67df4a3ca"
    sha256 cellar: :any_skip_relocation, ventura:       "f398a348812759267b3b4d1c90ef6bc039581c230d36eab43bc3f276d5c305ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ddcc0abbe06c9376e57ff0061c16f678bfae3e3c2ede7e9ec7c805ec6131fd7"
  end

  depends_on "dotnet"

  conflicts_with "coffeescript", because: "both install `cake` binaries"

  # Backport NuGet 6.7.0 -> 6.9.0 update to fix build failure:
  # error NU1904: Warning As Error: Package 'NuGet.Packaging' 6.7.0 has a known
  # critical severity vulnerability, https://github.com/advisories/GHSA-68w7-72jg-6qpp
  patch do
    url "https://github.com/cake-build/cake/commit/3e1841de021614504ccf9b96816421f943122726.patch?full_index=1"
    sha256 "bf3feeb71b577273ac8e69dbf38c9b9bdffa9b89e091d3a432192a5dec428941"
  end
  patch do
    url "https://github.com/cake-build/cake/commit/c72f1d2f429c641dbfdbae843defcab31f22e959.patch?full_index=1"
    sha256 "fd96a28c82b7dd404c7731fe69bcae75a863367dbfada9f0aa8e5af39d3a6491"
  end

  def install
    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
      /p:Version=#{version}
    ]

    system "dotnet", "publish", "src/Cake", *args
    env = { DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}" }
    (bin/"cake").write_env_script libexec/"Cake", env
  end

  test do
    (testpath/"build.cake").write <<~EOS
      var target = Argument ("target", "info");

      Task("info").Does(() =>
      {
        Information ("Hello Homebrew");
      });

      RunTarget ("info");
    EOS
    assert_match "Hello Homebrew\n", shell_output("#{bin}/cake build.cake")
  end
end
