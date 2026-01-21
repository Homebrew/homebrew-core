class Dug < Formula
  desc "Global DNS propagation checker that gives pretty output"
  homepage "https://dug.unfrl.com"
  url "https://github.com/unfrl/dug/archive/refs/tags/0.0.100.tar.gz"
  sha256 "bc7df36788cc4bb1ee01cfbaa670e4f8f97280d1906710360b5702764dcbda28"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23787c7d97ce2261c401cf7ea9e6634ac219c734a601860bc8569ad42422dd05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62abd150e0fbc780d10467802dd4bc25c82a20355835ee99dcebbbf48d841622"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6696bc5560f48ab96bc2fe25b6006f6e0c30b7642e158dbda41dc3245a774683"
    sha256 cellar: :any_skip_relocation, sonoma:        "99a8effa57c0eab19d80a0ba2b072306a108d475b685e076a2c94a339f373a68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5de054a2a7a81e6dd3e48db5ef8762d8fd8b30b752e60d5bdf394d9df55f67a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a31afdee8e8f9deedbad4fd048e026814f6bb8a5dee2a307e05ec374cab9d01d"
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
