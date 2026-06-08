class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "602129487eb5df2f67f659438e1b76c18a2b25dc1cdbed396ddf544a75fad45c"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55b8e8ee8f76b6cbc04e24d259f4b2f44daa5221c1c54341d101eecb7ea1eadd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55b8e8ee8f76b6cbc04e24d259f4b2f44daa5221c1c54341d101eecb7ea1eadd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55b8e8ee8f76b6cbc04e24d259f4b2f44daa5221c1c54341d101eecb7ea1eadd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9aa869d02ffad78376acef7a40d84b27b65d57af70893bf1c22ce77aa1f515a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe36bc893850482f9ac831ce8ddda389de042a8a5daf6277fd3457388deb94cc"
    sha256 cellar: :any,                 x86_64_linux:  "69fb1bb27bf36874db62d7e382472a987f677a35c48e834c6bcd9d715a0de6ad"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end
