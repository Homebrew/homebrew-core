class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/archive/refs/tags/v2.62.2.tar.gz"
  sha256 "52c07971483b6af0be235388ab606baeb87e61fb4406e37a4383cf57773b6f11"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf09cc37abae6cedc3ffd516ca7058c7fefe0c7654b84b06377a9bde28073b56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd1fe50fd94cc1992d7bf967111a58c3744bd6be967283d6a9ffc95bec93a70e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47f2711a36d275aa544fa52a79f02f8adaf86b54e60c3891ba425421f63913e9"
    sha256 cellar: :any_skip_relocation, ventura:        "7ef149d0bcf68bf0a47b146461ed3f4fdc21ff3c42169d465e96e452c0dd3cf0"
    sha256 cellar: :any_skip_relocation, monterey:       "d9aa4f68cba90f9f74e1d4db497e6d63c946b22e7a40169c5e5d73902bf9bc69"
    sha256 cellar: :any_skip_relocation, big_sur:        "547b7c4a554d31979dbe9f4dd30b7ef4f33d4cc7b88189d5f3a5e31cd68c1010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "418e363d85bd4d12be29682c9f314921874149e2915a375d04fb50b133e24330"
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
      /p:Version=#{version}
    ]

    system "dotnet", "publish", "src/docfx", *args

    (bin/"docfx").write_env_script libexec/"docfx",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    system bin/"docfx", "init", "-q"
    assert_predicate testpath/"docfx_project/docfx.json", :exist?,
                     "Failed to generate project"
  end
end
