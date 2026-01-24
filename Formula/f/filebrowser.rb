class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.56.0.tar.gz"
  sha256 "7c736f0bf298e7f1571a89965b81dc51de8db508282e6849bee7d95a50dd98d7"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee007fc998edf380132767c4f3242ba4ee3b570d095ff4e7716e35fd19ccdee0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2eca19c409a56d0750dc226dfb55e2771e1011721d80f392e31d16a52da753f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f62557759fff5698bad8f9ad06ed37462625ee7415c3279f548edbfffb96beb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdefdcb57d0c8068039f3a7b3b4e4d51f8d7b43e36844e4ce1418ee4a43c606a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a702b504ced1ab19c5f39f40ed2b4b13734183354d4c4afb9089c89e681a7fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb6c7efe8fbced69a14b5634b7f386a2461f6ba7ecb7c9a8b757326322bd6acd"
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
