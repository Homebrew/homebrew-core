class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.63.16.tar.gz"
  sha256 "56207b9707eefe9506bf66c3ca0ae06bee7d8834e84a37e1e8c3ece5afb4f79d"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd0a7fcc62eb24fc4fbada461e3ce36fa7b2d72c6a73db7a234ca01a644530fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c56403a4ae702ca0fbb3342a7c1d83badae97cd33f271bfbe54453c046f2545d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d85ee44dd8cda07e48ecfefa21e8344decfd6d191383f53e62b85f5c31eea85b"
    sha256 cellar: :any_skip_relocation, sonoma:        "556179368ee69b46310661db834224357aadf712451bf86811a8a9e26483f811"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91e3fd08ad04e115558cd5974435d8614eab3ad510a189dea5d17728e918bd44"
    sha256 cellar: :any,                 x86_64_linux:  "d2f01f476ac77de08b47795962278b97c6b84c86f51ceff46fb4b2d511d67354"
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
