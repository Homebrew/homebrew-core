class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://github.com/microsoft/kiota/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "3352bebc0bb7c3dea6719d03a39030b45aa6d503f0775feb7e80c65f8af0827a"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9ae0aa0b7e491cdb9a3722d14fff7a5d24314382430f5348f96b395bec0cc10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2ccf72b14ad28c1b29821bfc77119ce61d961c548b4116d17a753b3533c670c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cd3e901d75578c8d86d3628db466e1180b75d0c73f22baea22fdb0341b0b487"
    sha256 cellar: :any_skip_relocation, sonoma:        "296c9bcc2d37dbca0712f2d8b36e4a7da310d0ad0e8eaa729f1b483cf1ea0b7f"
    sha256 cellar: :any,                 arm64_linux:   "f7a0283707f5d5509f97e9adf8cba541a193362598567e039a8bc4a999ad8a4e"
    sha256 cellar: :any,                 x86_64_linux:  "5d5bb780551bf11296721c1e21eecf5502d6a5129df51eba6b19faae568ffa30"
  end

  depends_on "dotnet"

  def install
    # Ignore dotnet version specification and use homebrew one
    rm "global.json"

    dotnet = Formula["dotnet"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:TargetFramework=net#{dotnet.version.major_minor}
      -p:PublishSingleFile=true
    ]
    args << "-p:Version=#{version}" if build.stable?

    system "dotnet", "publish", "src/kiota/kiota.csproj", *args
    (bin/"kiota").write_env_script libexec/"kiota", DOTNET_ROOT: dotnet.opt_libexec
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kiota --version")

    info_output = shell_output("#{bin}/kiota info")
    assert_match "Go         Stable", info_output
    assert_match "Python     Stable", info_output

    search_output = shell_output("#{bin}/kiota search github")
    assert_match(/apisguru::github.com\s+GitHub v3 REST API/, search_output)
  end
end
