class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/refs/tags/v0.3.45.tar.gz"
  sha256 "5dc8802b6ffdd9c6859b97de6eff71ebdaf5c6db916a832f8ef694569de79178"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d7c11e4d5e933c0cece9d6fc9af8f81d6ff3ab0b334364c2eb9e32dcb35adc34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20b4514e5b71dc23b8a9ac6a51f0d41c243253d2b5d7bd478878bb9997950e68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdbfeca300caffd35f51e74ce2dbd71d2131f3da43253689909219f55829783f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c952e29a6e9d957d96a91b469625930df6399aaa119ff84a438aad1a5e106628"
    sha256 cellar: :any_skip_relocation, sonoma:         "20c354bb829e87b9717f3e7a07383524898a98ba4b95d45cf7bd1fae66524d1e"
    sha256 cellar: :any_skip_relocation, ventura:        "769b04d7c0432dc3ba36636c45e552618a948118dc10291d4bf4f181f221f694"
    sha256 cellar: :any_skip_relocation, monterey:       "68222aa5bfdb48c1a4d13fabce1b17becccb7f8f78020a8d304ac52c8870fcaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf2133c09cd94b30bbef81cea84f8b75a032238a07d8146cea3b04ff30eba238"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/tensorchord/envd/pkg/version.buildDate=#{time.iso8601}
      -X github.com/tensorchord/envd/pkg/version.version=#{version}
      -X github.com/tensorchord/envd/pkg/version.gitTag=v#{version}
      -X github.com/tensorchord/envd/pkg/version.gitCommit=#{tap.user}
      -X github.com/tensorchord/envd/pkg/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/envd"
    generate_completions_from_executable(bin/"envd", "completion", "--no-install",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh, :fish])
  end

  test do
    output = shell_output("#{bin}/envd version --short")
    assert_equal "envd: v#{version}", output.strip

    expected = if OS.mac?
      "failed to list containers: Cannot connect to the Docker daemon"
    else
      "failed to list containers: permission denied while trying to connect to the Docker daemon"
    end

    stderr = shell_output("#{bin}/envd env list 2>&1", 1)
    assert_match expected, stderr
  end
end
