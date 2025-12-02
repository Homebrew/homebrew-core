class GphotosUploaderCli < Formula
  desc "Command-line tool to mass upload media folders to Google Photos"
  homepage "https://gphotosuploader.github.io/gphotos-uploader-cli/"
  url "https://github.com/gphotosuploader/gphotos-uploader-cli/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "180ced2507d796b2305627097017aacd2b0206e1131e0b40da2a46563a823ec1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c496799ad9253eba958edbc09656b60f84e137c7339dc8dbace62f11d44aa71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa748744f457796bf0f912c08991f28c726ad87c189612ed21ef2166b3830fa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f789a31eba4645a812acba6da8454f978f0d77d5937df5b59fb8d7362929282"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "572fc38dfee39c7a521012aed7091c1e37d878693d7114f0148b0afba599cf46"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ee2b6060f65acd43ddcf2871631c39f7f816e268ad82520e8f2befe94ba6c29"
    sha256 cellar: :any_skip_relocation, ventura:       "612e7002d5ce131db1a6af66ec08758322397ae633d2a0a06c05bdc2729604a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa37a85126877e91eac08cc24f12c42f7f6383123f33b0fe437bd56bf824bdba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "810c2f4ca098336576917154aa30bfa7e93a7f5ce3771af97be37be10dee9a36"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gphotosuploader/gphotos-uploader-cli/version.versionString=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gphotos-uploader-cli version 2>&1")

    system bin/"gphotos-uploader-cli", "init", "--config", testpath
    assert_path_exists testpath/"config.hjson"
  end
end
