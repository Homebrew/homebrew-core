class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "63aec3843db10acb8d6455ffd768ea987e3a5687f88b61aa33e6e5003c2786ac"
  license "MIT"
  head "https://github.com/alecthomas/chroma.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f46b9ff72f1b5fc85d4b08dff366ccc7619730ca277c2e6f380d63efa6f53f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdb12c76b2e422651a57d5825f0a932e63df62c452366ee34c6412ccd71fb7ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdb12c76b2e422651a57d5825f0a932e63df62c452366ee34c6412ccd71fb7ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cdb12c76b2e422651a57d5825f0a932e63df62c452366ee34c6412ccd71fb7ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f935044062a7903bbd3585905a8bb564844236dcd232806fdb69828b18d1df0"
    sha256 cellar: :any_skip_relocation, ventura:       "3f935044062a7903bbd3585905a8bb564844236dcd232806fdb69828b18d1df0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66d7f12d81a4ac8193b49343b87b9b3a377c5b0d47558841afdd81b3e88075bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2601da81eafe25841d6fd42c87f7b312a29166f7ccc3dfe53d17ac73e1057bd"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end
