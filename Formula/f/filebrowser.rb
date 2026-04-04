class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.63.0.tar.gz"
  sha256 "68ef79b4e48aa80a4921f395a55b6ba9efa58c0fa95a6de0915fd27348af59bf"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb179e76053127f6a1a68264bddeea445bde6b748c7c645c926b690de41b3ef9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4430562df642917241f57ae9607a31f869a4442327c0013dd9a181061387c59d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc4684a83c6500eaf8d38fc18fba086fef987abffdc1a94599aac3695d5ba85a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbf1135e49b2589fa002615df78e74baf77325e0af7a5d92ef62224cce81142f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67f8b3922c5d05ffe1e0070392ebe341834a8ce7da1305a4c8e9a1c648f51b7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "405d507310885864d82e6152f6d182b1e1a8444d6176a4ecfdba982852c2d532"
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
