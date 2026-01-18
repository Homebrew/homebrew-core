class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.54.0.tar.gz"
  sha256 "0752cc7444e2f327cb4beefe6eb40493bfd2f5a077daa2e5dbf6ace013cfc34d"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3de2fd5e4c6e976645f430e03f59dac1e2830bf62ec535d7be8b8f68f06eb08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d110ce98f6e640cb65ad07e61b1ea05ea6c7c5b79381645fc9ad1da2f735eed6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d809b5c103240df294de5a5fb84338a53d80b82731bfaf4045e97e99facc732"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ef231e3063f31d95c5258118bb03538b9e4bd2809b11f862be2856df2ea1b57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ac1eaec813611e06ba3187b2c0ea8fbc92bfc43b42619b2034ee6943976154e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45341486a5a481763faa6dc0c95b91e2ec8a30f8a31dd8385a1f294f12a89a05"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/filebrowser/filebrowser/v2/version.Version=#{version}
      -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"filebrowser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filebrowser version")

    system bin/"filebrowser", "config", "init"
    assert_path_exists testpath/"filebrowser.db"

    output = shell_output("#{bin}/filebrowser config cat 2>&1")
    assert_match "Using database: #{testpath}/filebrowser.db", output
  end
end
