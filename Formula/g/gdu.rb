class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/refs/tags/v5.26.0.tar.gz"
  sha256 "5e7dbaa83ab2f9c7e39e44b1533907a6ca41b5c019b04647286bc7c1a435a555"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c46b9a1c3b49087e3f3f67e63c87257af8527d1a501362230f18d8f1dbf0f72"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3935903c00bb0e200f2174b9f0fe390adadca6e99b87f2bd1daee720aed0261"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83b8a1bf49fc89991fe64bfe7d62c5aa78b514c4c8f740bb19638918296791a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "a055fcde745d29aac5394977404a643245e1f6aceb0916b688e4cd07562b3b06"
    sha256 cellar: :any_skip_relocation, ventura:        "8d433d4b5679a6b84a0d683215c3a912695701da19e4473676dcc921799cafa4"
    sha256 cellar: :any_skip_relocation, monterey:       "29f1570777e8494bec0a063fa53238bff1ee855c32b7fabdb5e8327f8b4fb7d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc5645f6c5afee30de82ee6e87f1711b68ca9c4f70a8efc7de71b63e3cf0d409"
  end

  depends_on "go" => :build

  def install
    user = Utils.safe_popen_read("id", "-u", "-n")
    major = version.major

    ldflags = %W[
      -s -w
      -X "github.com/dundee/gdu/v#{major}/build.Version=v#{version}"
      -X "github.com/dundee/gdu/v#{major}/build.Time=#{time}"
      -X "github.com/dundee/gdu/v#{major}/build.User=#{user}"
    ]

    system "go", "build", *std_go_args(ldflags: ldflags, output: "#{bin}/gdu-go"), "./cmd/gdu"
  end

  def caveats
    <<~EOS
      To avoid a conflict with `coreutils`, `gdu` has been installed as `gdu-go`.
    EOS
  end

  test do
    mkdir_p testpath/"test_dir"
    (testpath/"test_dir"/"file1").write "hello"
    (testpath/"test_dir"/"file2").write "brew"

    assert_match version.to_s, shell_output("#{bin}/gdu-go -v")
    assert_match "colorized", shell_output("#{bin}/gdu-go --help 2>&1")
    output = shell_output("#{bin}/gdu-go --non-interactive --no-progress #{testpath}/test_dir 2>&1")
    assert_match "4.0 KiB file1", output
  end
end
