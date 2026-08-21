class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://codeberg.org/roble/noti"
  url "https://codeberg.org/roble/noti/releases/download/3.9.0/noti3.9.0.tar.gz"
  sha256 "02b18016f6a78a1adf3cdcc5b20d884437edd0cf21588415e022d637372619b8"
  license "MIT"
  head "https://codeberg.org/roble/noti.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "593d9bd0ba1d76a703c4e3df96c307ce77298933e5cd599495cdb2217a962ba0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "593d9bd0ba1d76a703c4e3df96c307ce77298933e5cd599495cdb2217a962ba0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "593d9bd0ba1d76a703c4e3df96c307ce77298933e5cd599495cdb2217a962ba0"
    sha256 cellar: :any_skip_relocation, sonoma:        "924502ce53d355628d16ab324f3f11fe3cadd7c7ef965d852e7f42fee718766f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9921b9b6c7ffb236673b81ae83aa8401069e9676341312a287376331d0dda5da"
    sha256 cellar: :any,                 x86_64_linux:  "590924c22fc852140b1d7806371dad64686469f0df0179cc34e0da81d32ab588"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X codeberg.org/roble/noti/internal/command.Version=#{version}]
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
