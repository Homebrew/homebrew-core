class GphotosUploaderCli < Formula
  desc "Command-line tool to mass upload media folders to Google Photos"
  homepage "https://gphotosuploader.github.io/gphotos-uploader-cli/"
  url "https://github.com/gphotosuploader/gphotos-uploader-cli/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "99fdc60442f8ff39a01dc97544509749553279ea03caee230a055eb0fcdf0e7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1c23351fe1a3a15f1619e7d3673191e04c588ba8a710b3f2f001c0591ca66026"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6df1ca0bee16f4a08e1b7b496e7abb8bc0315158dd3cd6203c41467417f09c6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3c721cd99a4ede123a59eb987d186b758a99a56594b6ba3c1ffd7371b1f6fc4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d14928daae187c279643068f15f9e75e22eaa6eadea0920d83603aa3c34595f8"
    sha256 cellar: :any,                 x86_64_linux:      "ab35dd2c359515de0fc5aaf76b6fd3844849fcb52d5b29670eae0dacd797b8ad"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/gphotosuploader/gphotos-uploader-cli/version.versionString=#{version}]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"gphotos-uploader-cli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gphotos-uploader-cli version 2>&1")

    system bin/"gphotos-uploader-cli", "init", "--config", testpath
    assert_path_exists testpath/"config.hjson"
  end
end
