class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.63.14.tar.gz"
  sha256 "5611ca536a19e377132e0c344b48c26f45f80513fd8de6a65c960aa5c9c4ee62"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d94cdb6c7ee104886fe3a9f8b4ecbabf22a4cd1fac452b6428d14da8c70fdd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2004fa13ea1138189178df7cbddfeff47c916724d6bbe9d8e85b68cb0390bce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68f937a7074ce6c2b9a7dc6a9d480a48be806f00b225b77d3e6c4e1d0b1284a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "76b30bab49d77a0aeed4df371bc870aea90dd5c1fb7f31b67cc12184ab376257"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6edd52fa4ef0ca78e4d9644d673ecc085ec071986951e0096852df46c2196d9"
    sha256 cellar: :any,                 x86_64_linux:  "3be90384f6ab1c23bfcaced644d6e8eb4de612e57d52878d240e8a621c61d9cb"
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
