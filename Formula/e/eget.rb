class Eget < Formula
  desc "Easily install prebuilt binaries from GitHub"
  homepage "https://github.com/zyedidia/eget"
  url "https://github.com/zyedidia/eget/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "9b392ecb5db6917283f5186c0bd9eee43c04f8c6a0a139a11bf8dea323f717c7"
  license "MIT"
  head "https://github.com/zyedidia/eget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49a218d881b21e13652107b3c8e126435f1c7769982ffe6dda0e85d64cd66df9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d12208bcfb78ab79dbf71d076755a6408b1f2fa2667b1bc50392fd8544fda4e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d12208bcfb78ab79dbf71d076755a6408b1f2fa2667b1bc50392fd8544fda4e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d12208bcfb78ab79dbf71d076755a6408b1f2fa2667b1bc50392fd8544fda4e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "444bee002b8580f6d95dedbf3ff9d649779d9dc8d96d44eb2e3bfcd7f55e92d7"
    sha256 cellar: :any_skip_relocation, ventura:        "ce1eef77db41af69a43512c68bd3ab588efac186dcc4d1c7d4416fe62b8f66ca"
    sha256 cellar: :any_skip_relocation, monterey:       "ce1eef77db41af69a43512c68bd3ab588efac186dcc4d1c7d4416fe62b8f66ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce1eef77db41af69a43512c68bd3ab588efac186dcc4d1c7d4416fe62b8f66ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb006b82366dcee9f67b47c24b75145d3e3fc714291056927a12bd141e6d4ef9"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    system "make", "eget.1"
    man1.install "eget.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eget -v")

    # Use eget to install a v1.1.0 release of itself,
    # and verify that the installed binary is functional.
    system bin/"eget", "zyedidia/eget",
                       "--tag", "v1.1.0",
                       "--to", testpath,
                       "--file", "eget"
    assert_match "eget version 1.1.0", shell_output("./eget -v")
  end
end
