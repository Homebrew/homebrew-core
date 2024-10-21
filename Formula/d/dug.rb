class Dug < Formula
  desc "Global DNS propagation checker that gives pretty output"
  homepage "https://dug.unfrl.com"
  url "https://github.com/unfrl/dug/archive/refs/tags/0.0.94.tar.gz"
  sha256 "f97952be49d93ed66f1cc7e40bf7004928e6573077839a18f5be371c80e2c16b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fc22af9ae66c539b84fd9202cc15442c5cb9ccc2da736c25073c01cd7cb7d1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b218fc33ff689d05ad7637d3a90516eff22c12721dce9c45a6bc0b9d7d8005b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2b486b453398832444fe293c2114ae52415e32450a307efd4f8d794e612978b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bafbcd64d21759be827798be5e716d58f4c5b25272884d6efc517d0c56a88885"
    sha256 cellar: :any_skip_relocation, ventura:       "c5fca1866650201da0bf750a980bb99c02635b45c10d12f07de0dd004ea65b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "373a0464e15b4ceb0af958ceaf67c701946f521bec7654477f0036b585aff48c"
  end

  depends_on "dotnet"
  uses_from_macos "zlib"

  def install
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"
    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
      -p:TargetFrameworks=net#{dotnet.version.major_minor}
      -p:Version=#{version}
      -p:PublishSingleFile=true
      -p:IncludeNativeLibrariesForSelfExtract=true
    ]

    system "dotnet", "publish", "cli/dug.csproj", *args
    env = { DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}" }
    (bin/"dug").write_env_script libexec/"dug", env
  end

  test do
    system bin/"dug", "google.com"

    assert_match version.to_s, shell_output("#{bin}/dug --version")
  end
end
