class Dug < Formula
  desc "Global DNS propagation checker that gives pretty output"
  homepage "https://dug.unfrl.com"
  url "https://github.com/unfrl/dug/archive/refs/tags/0.0.94.tar.gz"
  sha256 "f97952be49d93ed66f1cc7e40bf7004928e6573077839a18f5be371c80e2c16b"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55979db9263fecfc0b8e2e5f3ec5a1c9f51e7e867ff0dbeae546e5503e82616d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2056f58b7a98102e267466ac4b78cb0c20f6d718edadec02e99711e73c63f1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a0694076a8ca9f24aa8105df5400385905f0346365c0d9ff663180126657aff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7caf9fe29373fefb13ca554c3e58d0ac96cc4fb5f4a210d2ff28162a0a2d96d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fcc35f470be76307cf14e8ced656a65749c49f65e63df5e267494596199eeb4"
    sha256 cellar: :any_skip_relocation, ventura:       "4fd87cddb2e79d2fa8f92f0534b386767e8670c481091ada9574e5944813bfcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dcf74573e47126fe1226d4a2bcff3d5b2240f756cc7756ca064cb35268b6110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ce1254977a436fccb15cd219228dbb012ec7722d91e883b4a47bbd277e19803"
  end

  depends_on "dotnet"
  uses_from_macos "zlib"

  def install
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{bin}
      --use-current-runtime
      -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(bin)}
      -p:TargetFrameworks=net#{dotnet.version.major_minor}
      -p:Version=#{version}
      -p:PublishSingleFile=true
      -p:IncludeNativeLibrariesForSelfExtract=true
      -p:DebugType=None
    ]

    system "dotnet", "publish", "cli/dug.csproj", *args
  end

  test do
    system bin/"dug", "google.com"

    assert_match version.to_s, shell_output("#{bin}/dug --version")
  end
end
