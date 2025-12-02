class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.50.0.tar.gz"
  sha256 "5947c8a8c7c8df2b2646953cfa1fdee9efac8b4415a368074acab94eacc56fd7"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "929d40d7130902b8a2573e8dc8bed21cea8cd4c6f71c2d79e3512affebb5a4de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59520641823b4240ce3f7da81c9a3badbabf2922262d8152522d2f3c40456bbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef2b00cec1fe60a9a621d78e8e4c882269aaf6df107d78c25a436f26463251c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8569a96e23c901e43e678a3915f16a9231c09c664869d3eaa8629340c6fb1d8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e14287599cf4a2f86a53618789df210fe6203c6a5a9e257e381df3fe1ec0956b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46586ddfec6b78a6a5a0f5ff53c28d555526872f9c3a04e3e8eb1d325162b37a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/filebrowser/filebrowser/v2/version.Version=#{version}
      -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"filebrowser", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filebrowser version")

    system bin/"filebrowser", "config", "init"
    assert_path_exists testpath/"filebrowser.db"

    output = shell_output("#{bin}/filebrowser config cat 2>&1")
    assert_match "Using database: #{testpath}/filebrowser.db", output
  end
end
