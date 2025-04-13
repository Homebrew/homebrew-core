class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://github.com/microsoft/kiota/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "dd1ddf6ea932b721d5a6fc9bf8daa2aa119e27d54d1e130414b5a0525fcab3ec"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b85fdfbd697f0076c5569d3bf31171a5b1655c7548a579a966cb497bbd508320"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc6a0a928b93c8eca64955cbea33b8a7028e4c9da9f5985ade8e400237efff0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08c2bd45e4c21e0121e43fecdd024941f22692a7288d2e454ffceeecc3ae9766"
    sha256 cellar: :any_skip_relocation, ventura:       "f40d2032d7e6b3a0a41f2c58e6a3f4d8f3f7871e9b166798472601ae5fbb240c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a863c0c73ee8a1f21d090216da19455f69141048af0c296fefdadc6980c0917f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33229f52713a580169d7aff9fa7e55575238ea758c8141d4fad99e75747eca8e"
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
