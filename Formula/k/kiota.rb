class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://github.com/microsoft/kiota/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "cab39c2bffd20db3c8f31653ba1f0cb9fa3be785f38ff62422be76a34030dee6"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6d3834ef9059ec491aa9ac378b0bf4917167c88b0d4296061cdc5c06bd6a799"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c2e623027cd4168564aab495ea0bcedf87b932b0c158dceaa2bd517e60a30db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fda10609af91d6a2b002826836ca5c0d5573ab9d6de9ec258e1127fc6259e10"
    sha256 cellar: :any_skip_relocation, sonoma:         "5eaa149956c37d895ad1d655726c08117ad0ece152d30027c5f929d8c5ed12c0"
    sha256 cellar: :any_skip_relocation, ventura:        "845ca55139c474e03109361fcb87b5a67eac1d4ef05bc147c0b59891ce8afb4e"
    sha256 cellar: :any_skip_relocation, monterey:       "ec703101371a665c8e625ba124ba3d15ade91e10eb144060b07f02987090cb27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "827b2e9eaf626071c263ba62d7a5ceb14a79d613561844b31b9a152b58e3e2db"
  end

  depends_on "dotnet"

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
      -p:PublishSingleFile=true
      -p:Version=#{version}
    ]

    system "dotnet", "publish", "src/kiota/kiota.csproj", *args

    (bin/"kiota").write_env_script libexec/"kiota",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
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
