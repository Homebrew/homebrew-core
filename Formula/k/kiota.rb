class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://github.com/microsoft/kiota/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "aec6a8c4a9b8916e45a63063e8b8f73b3c254b60669f3305d39407eeabac0135"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19a38b19ceef31efe51cc4293e1b1ee698710a53a5f8f7b5e9d0e452a92fd2b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "860325dfc1f9cd1ccba1373ff011c96c47a5e2c7444f4d09a77cadc3ce587af2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb077afb1d34e3abb97c60bc1f12606054b95aa1440baf9476ffc5b18e2a23d1"
    sha256 cellar: :any_skip_relocation, ventura:       "ca7665ea8701539a9a4f8203a8ec60a433a4b9ca4817ca069ad3a79354a90aec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6723c526799374b78368a0a1d6fc1b2bfcaf4537de8d48e3cfdd4a3e8450503c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7596fe271778ba74bd1f3711d845e7e730919408ef1c718198ebb50192dce91d"
  end

  depends_on "dotnet"

  def install
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
    assert_match "Go          Stable", info_output
    assert_match "Python      Stable", info_output

    search_output = shell_output("#{bin}/kiota search github")
    assert_match "apisguru::github.com                            GitHub v3 REST API", search_output
  end
end
