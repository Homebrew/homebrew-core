class GphotosUploaderCli < Formula
  desc "Command-line tool to mass upload media folders to Google Photos"
  homepage "https://gphotosuploader.github.io/gphotos-uploader-cli/"
  url "https://github.com/gphotosuploader/gphotos-uploader-cli/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "180ced2507d796b2305627097017aacd2b0206e1131e0b40da2a46563a823ec1"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "619c45e2f8edb6b143cf1face0d0f1ec3850f84fda574a35678666f29811ea0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "439dba9cb6761a9c18bca09c2211116175b3e97b4aad428cf83e585a350715c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b263b761cbbc70a285ac6911ccbef19425eb53f9b04a01f7e36e73bf04f11d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d22f32e0a810b842b2e4732d6a75d862a71b2af77859919b87131f9947cdb79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "210a7402f800452b5acf3c5759d03c3173fa775567377536cdada1ab962abf10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54ba84dbd457e5fde7e704902489b5b2f98fcc3871f112599b8dad26c674bbf2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gphotosuploader/gphotos-uploader-cli/version.versionString=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"gphotos-uploader-cli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gphotos-uploader-cli version 2>&1")

    system bin/"gphotos-uploader-cli", "init", "--config", testpath
    assert_path_exists testpath/"config.hjson"
  end
end
