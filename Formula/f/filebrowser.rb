class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.63.18.tar.gz"
  sha256 "b665942fa4adb882498e89f09ef90f4690de4f22de043453c28e201c812060c5"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f99bf1ec275394954bffe8dd18835f5639b8456610486fbe3575b8052fab2836"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "527976a743a527f46309abf412674c67a6463c25f5b5658bcd784d9af9dc07ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00152a568ce28ffa0723e35c71b62819ab000779206155b654ab97420148a1a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd47392a37187b7a368b0b11b6fc85c458c8e082571e18d4d4e8f4d4c26cecce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dafb4af6f3bf4dd922da9124e36ca21e1206860dc0c7d2f6ec74663e3e1db254"
    sha256 cellar: :any,                 x86_64_linux:  "c40e2361bb72a5516567650840ec96d8bcc4a29d5577da8c0a351539a0cf3ff9"
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
