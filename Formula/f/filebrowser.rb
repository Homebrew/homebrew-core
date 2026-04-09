class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.63.1.tar.gz"
  sha256 "6f1b63bc8add3807d67c09d03ee60d2282255fe11b6ab6fcfc06266e9fb743fd"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "478db3a098d2eaa666a64e95639f29d8d6275f68d38d310d3916dfd3ad546fed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22c40132dda96e38d914fd4848d82351979ada0369a37b4506e2f435334597aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f74b001659beab2c74be5dc56e0dd8f88370bb8d5ee1a3894131d706ed99a6bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7218e00f8e61f352506e2d2327e921e5626bfe07c795269da59a537a32af592"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7692ca920992973b8e0a5efc9bfd970a7949ef1fd3e9e2cd7f9389096ea594de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "833d608ce63619f0fc3d7e0be8edb92f0e4b616dbb56aeccc464d03c8da91c50"
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
