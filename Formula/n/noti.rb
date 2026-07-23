class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://codeberg.org/roble/noti"
  url "https://codeberg.org/roble/noti/archive/3.8.0.tar.gz"
  sha256 "107b9169c63c623556f554d54d82118da72f871ad8eddda3a49a613ff7deaf30"
  license "MIT"
  head "https://codeberg.org/roble/noti.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "205fe66ef02286919f06b260301a75472820d41a914be5691af77a1cfb588301"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41ae7991b41308c734a42e36a7d436004224087da7897cc7f580a23ed5c8e5cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f076e36e31923537c7e15c47a468870a66ce4b80730040df5405d58a013df80"
    sha256 cellar: :any_skip_relocation, sonoma:        "39562685ad53b0bbf54a75820d138536ef69d7c9a9f51f22ba5cf8e3f23cc496"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d386468c18c625ea2abc7b43e00e37bae36e037496879522c60e6066e8ae3cf6"
    sha256 cellar: :any,                 x86_64_linux:  "abac47c0ec93ba018d66619164fafa2f6edb605681546fb04cc2e1d603fdf97c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/variadico/noti/internal/command.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "cmd/noti/main.go"
    man1.install "docs/man/dist/noti.1"
    man5.install "docs/man/dist/noti.yaml.5"

    generate_completions_from_executable(bin/"noti", shell_parameter_format: :cobra)
  end

  test do
    assert_match "noti version #{version}", shell_output("#{bin}/noti --version").chomp
    system bin/"noti", "-t", "Noti", "-m", "'Noti recipe installation test has finished.'"
  end
end
