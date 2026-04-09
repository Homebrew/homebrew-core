class FoxgloveCli < Formula
  desc "Foxglove command-line tool"
  homepage "https://github.com/foxglove/foxglove-cli"
  url "https://github.com/foxglove/foxglove-cli/archive/refs/tags/v1.0.31.tar.gz"
  sha256 "c8dcc85135ea375ec0d06e3ff8a0194a5c8756bac58d60d05bf2259be7d815a4"
  license "MIT"
  head "https://github.com/foxglove/foxglove-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbecdaa31a416270a4352110b4e432570dbce113053889791a8b2aa115d8ee44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e08df2a52faad8db844e5172f41d1ed7c73550e52abbec88083fa1bf4b7d1ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16ed66cdbff59115706e390dcc0aabca6e25d7aa8e77df27fb6ac94952bbf558"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e856beaefef6f0e557ee0fa19ac3e396fd8e34682d4adb9e324ec18c78801ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "115a2034a4c16aa7285f22f3b66383a8a82fc4824a42278d300ecfe229089bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccd8d2a1f61d8d8116e475a55f8fe350114b18dfa73989ccea90d7775f97d905"
  end

  depends_on "go" => :build

  def install
    cd "foxglove" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "foxglove"
    end
  end

  test do
    system bin/"foxglove", "auth", "configure-api-key", "--api-key", "foobar"
    expected = "Authenticated with API key"
    assert_match expected, shell_output("#{bin}/foxglove auth info")
    assert_match version.to_s, shell_output("#{bin}/foxglove version")
  end
end
