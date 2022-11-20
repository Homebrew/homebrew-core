class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.20.0.tar.gz"
  sha256 "a5c164192dc631370f6f5313979dda200b52146c4f780e5ad73bbdb96d996da7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd997fd3e96ebc59e6c817aedb3f0b8c784c6218eaa4332939a9c5f766aba2e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6551ad5d730103318db7c3b8aa96179cb2b78d7a8b1722f77edf9bc0fc9fe40b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f5b0f66324a6b10bb0f09ac684571d74cd04beb4d9b218ce70682332e7e3b26"
    sha256 cellar: :any_skip_relocation, ventura:        "a5dfc1be08654bb5a0137f3922aab7e58ecaaf8afecbb66ee16346577b076962"
    sha256 cellar: :any_skip_relocation, monterey:       "5d4cbe9b8ca4dd6c42862ca1dc87ce5fc2b31ee648b14fb6a332277447472eb9"
    sha256 cellar: :any_skip_relocation, big_sur:        "95c67a252a8ee1e48ee282c46ab6f3eea04047bd6cca9ecb9412d563a5c3107f"
    sha256 cellar: :any_skip_relocation, catalina:       "b8f310068ed8645e5ef621453700f632115a55672ec86f33ed25a8b3cad7c0df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d87e62c098adba42a64e1a61367127933ccb2fab420a435dc535eff2715a6f70"
  end

  depends_on "go" => :build

  conflicts_with "coreutils", because: "both install `gdu` binaries"

  def install
    user = Utils.safe_popen_read("id", "-u", "-n")
    major = version.major

    ldflags = %W[
      -s -w
      -X "github.com/dundee/gdu/v#{major}/build.Version=v#{version}"
      -X "github.com/dundee/gdu/v#{major}/build.Time=#{time}"
      -X "github.com/dundee/gdu/v#{major}/build.User=#{user}"
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gdu"
  end

  test do
    mkdir_p testpath/"test_dir"
    (testpath/"test_dir"/"file1").write "hello"
    (testpath/"test_dir"/"file2").write "brew"

    assert_match version.to_s, shell_output("#{bin}/gdu -v")
    assert_match "colorized", shell_output("#{bin}/gdu --help 2>&1")
    assert_match "4.0 KiB file1", shell_output("#{bin}/gdu --non-interactive --no-progress #{testpath}/test_dir 2>&1")
  end
end
