class DerAscii < Formula
  desc "Reversible DER and BER pretty-printer"
  homepage "https://github.com/google/der-ascii"
  url "https://github.com/google/der-ascii/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "e59e795eb12ed7618f8ac6fe3969277145536b1705c205d387f1bbc53c418160"
  license "Apache-2.0"
  head "https://github.com/google/der-ascii.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4a18fe39f98ab330d0be623e93e92fc7fc21663a21e8fedb2e0c4108e42acce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4a18fe39f98ab330d0be623e93e92fc7fc21663a21e8fedb2e0c4108e42acce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4a18fe39f98ab330d0be623e93e92fc7fc21663a21e8fedb2e0c4108e42acce"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f90e0345b09d95c169528d54c1910032ff8cda324a16fd80db4e9c5c8320dfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "841b6ec4e24ecd59cece4aef187231f63b7fe67e61534ed43cd9c3d1aa80055a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7313f36585dbab7370d770765e0e8e974dfa6da731d44e0340c193307b83659"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"ascii2der", ldflags: "-s -w"), "./cmd/ascii2der"
    system "go", "build", *std_go_args(output: bin/"der2ascii", ldflags: "-s -w"), "./cmd/der2ascii"

    pkgshare.install "samples"
  end

  test do
    cp pkgshare/"samples/cert.txt", testpath
    system bin/"ascii2der", "-i", "cert.txt", "-o", "cert.der"
    output = shell_output("#{bin}/der2ascii -i cert.der")
    assert_match "Internet Widgits Pty Ltd", output
  end
end
