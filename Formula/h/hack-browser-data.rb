class HackBrowserData < Formula
  desc "Command-line tool for decrypting and exporting browser data"
  homepage "https://github.com/moonD4rk/HackBrowserData"
  url "https://github.com/moonD4rk/HackBrowserData/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "80d2b77ba764aaf88bae49d7a071c0309b8fb05f45af884b407ec58183b6478c"
  license "MIT"
  head "https://github.com/moonD4rk/HackBrowserData.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7b249fa7e8dc58e6e3aa31174dff9d67b788d91248866c5e9e60cf0c7e06c4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7b249fa7e8dc58e6e3aa31174dff9d67b788d91248866c5e9e60cf0c7e06c4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7b249fa7e8dc58e6e3aa31174dff9d67b788d91248866c5e9e60cf0c7e06c4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "04be65e5e5a9e26b6021468947d1052ce9453a07bc0c1daa2d02f3317e77fe89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eea96e3264bb785543efea3792ff7f3167c530e5e11a134747ef386d4ae56123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43ce0a5471d222a7edb530c9370199fc6db91475b6fb9c47f17f23d870708279"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/hack-browser-data"

    generate_completions_from_executable(bin/"hack-browser-data", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hack-browser-data version")

    output = shell_output("#{bin}/hack-browser-data -b chrome -f json --dir #{testpath}/results 2>&1")
    assert_match "[WRN] no browsers found\n", output
  end
end
