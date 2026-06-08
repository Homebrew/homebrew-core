class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://github.com/microsoft/kiota/archive/refs/tags/v1.32.2.tar.gz"
  sha256 "2008cc39f0f3201cad3bc77030b3d5be58b73efab21bcc345268880cd2339191"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ae3f671acf6f0be46c023174f50f51631b007f4bac8e38002db3406d88eb335"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1594f47830380645dce4ccc847b8e8ecc254c79f26c5613fd7d333103414cd39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93add8482c7b35d6e5cbcd5f98998e9a2f231927db34aad2be35820114e5b866"
    sha256 cellar: :any_skip_relocation, sonoma:        "9789cb030adff2cbc59a573fd8edd343db3b032630dc32a69119c47bc7348a11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91c4b442f6eab050a4c9a558d3e043135eb56e5691c20f2dbac80abfd2870993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba4ba5ca470ef0a11ad8b12bf7fbf23894b9600f8b0ba69c6b6b758833fc56d4"
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
