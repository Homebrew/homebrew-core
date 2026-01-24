class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.56.0.tar.gz"
  sha256 "7c736f0bf298e7f1571a89965b81dc51de8db508282e6849bee7d95a50dd98d7"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d951f538464101f12080b6fc0679edca59c0c70bf4c2afdceb2d0bd9d16c037a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4a2467432f737bcc32efc50df53ec355ce56b0ae386c26c7e7c2d082df4986f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f51439af08f684962d95e12660b9e3a1691c19b82879fe1343526d438fc65f96"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d11523166f03eed0a74f1c2b4f6820493cec2cd35d3dbf0e271e63da324854d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "850657d20a796166135b1965c114a2af88164d40bb5056d3bf84ee597250685a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0e975f8596901785c9dbb36a058b47194c48f381af56339e8bdf3818aa8c204"
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
