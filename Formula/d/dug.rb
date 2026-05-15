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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68651322918983c7b3e0e1c1131fd2dfaf18bcc54410dd3a088b14aaac890dc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8a09c77a720e84d5977a0a2a6e7d5362d915adbb23a77df37ced1e3a74423a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9791a61fc43b2d7d38d0b25ec810263b76fbaf541fb964c26d6766e9c10a38b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9450c5733e42eacaf2a929ab39d89d6218146245aa6618e9b1ebaf856e314816"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9c006bc67d14e2e367b1d1783cc842571ecd099850e73ba3cf84ad1cb7b353c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da85a1f5e058349b15af0b48d9dd17b2ae3e8654f2f5f4170959cf3657c3e4d9"
  end

  depends_on "dotnet"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
