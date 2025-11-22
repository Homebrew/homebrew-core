class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.49.0.tar.gz"
  sha256 "5f35beedf818feef315d84222dd957b8e10fab65a80a7d6ff10e22a31a11722f"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3596f7de0398701abbc7bc1d5fdbab624937a842ca6d8de03e3feda07c1189d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f62f12a9e1faee7e4b7b12a0f9f423a964787b66c6fbc5622e6ad862e6908373"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a39f2569bcf653646c0ec96a44b8b226d29e8857b7beba48f518fabd0c93b16"
    sha256 cellar: :any_skip_relocation, sonoma:        "5209cfbce4e29700c01b8f0535ff4120c02a60a0bb28436fea0927d6a1d80923"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "258a37325334e9b2ee2c25268d7b50af5b7b0961b1de0e3b9b35d56823d3bf1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "239968b377f36b84f78cb1fd3e81d80b12e5e134411236299b55f249b392af78"
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
