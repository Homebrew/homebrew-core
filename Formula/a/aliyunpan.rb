class Aliyunpan < Formula
  desc "Command-line client tool for Alibaba aDrive disk"
  homepage "https://github.com/tickstep/aliyunpan"
  url "https://github.com/tickstep/aliyunpan/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "ff1d61705a55277b1cd9cb28b5edb12a3f9ed91070fc1a69b3366b42316cd294"
  license "Apache-2.0"
  head "https://github.com/tickstep/aliyunpan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41c7e5a431d4d970c6c5c91203e6ff05287ed23a4444630a71b07f453ed58ce6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a66818fbc60856757dbf912614b0e83851988f8df476fa1578621695ea80e8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1ba1f538d116dbb3fadfaf6bf626543b6c48f61e250cd2e7728d2b94edc38fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "7869b56a1c910db62544fa0835d9c3b2f4a55bdf6008ea53c18bee2d988ed1ea"
    sha256 cellar: :any_skip_relocation, ventura:        "dde5590b5331c9b2fa9908cf2216836761ddb589fa404fae5bf13dd29832e056"
    sha256 cellar: :any_skip_relocation, monterey:       "bffdd5d504721d60e37b7b7a45de60c6004d9408b756a0520733f1d04442c264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01473f45ad6304d964d6acd34b4b017b2667ed629b6203dbc0475a92ce6105f7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"aliyunpan", "run", "touch", "output.txt"
    assert_predicate testpath/"output.txt", :exist?
  end
end
