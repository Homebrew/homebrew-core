class LicenseEye < Formula
  desc "Tool to check and fix license headers and resolve dependency licenses"
  homepage "https://github.com/apache/skywalking-eyes"
  url "https://www.apache.org/dyn/closer.lua?path=skywalking/eyes/0.5.0/skywalking-license-eye-0.5.0-src.tgz"
  mirror "https://archive.apache.org/dist/skywalking/eyes/0.5.0/skywalking-license-eye-0.5.0-src.tgz"
  sha256 "bc1f80d65c69754ad56654c2c6fcd29c163ba2c0d7a10dde3145d55d353d1e74"
  license "Apache-2.0"
  head "https://github.com/apache/skywalking-eyes.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d5b5f7c2cd3ca03e747f9333d42a63e52c83b5971cb628462b8f6b5235d3b99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d905a19a34d29dfc5cfa2068ba214cdaeced705279d5b1b1e11309e232968175"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4aa5a271017ccdca49ba19853670bb8ccd73d1135f04d00df0381b1d541797c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "296eddfde7acf8558e627ddfe027be01e870be21999b04125c0fb46b73b23835"
    sha256 cellar: :any_skip_relocation, ventura:        "fc2a98fedc427622cf32a9e9f50ff35bd81ceca9a0351e49601d42fbdb655543"
    sha256 cellar: :any_skip_relocation, monterey:       "0c7d66067c3f133cda1696d86ff626c70d490e8ad27f719e51cd4e23275d98d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32d613fa2572aca434ec74731f507feade058b3f5befc0a36879e4bba160e63c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/apache/skywalking-eyes/commands.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/license-eye"

    generate_completions_from_executable(bin/"license-eye", "completion")
  end

  test do
    output = shell_output("#{bin}/license-eye dependency check")
    assert_match "Loading configuration from file: .licenserc.yaml", output
    assert_match "Config file .licenserc.yaml does not exist, using the default config", output

    assert_match version.to_s, shell_output("#{bin}/license-eye --version")
  end
end
