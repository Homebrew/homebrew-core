class Cdebug < Formula
  desc "Swiss army knife of container debugging"
  homepage "https://github.com/iximiuz/cdebug"
  url "https://github.com/iximiuz/cdebug/archive/refs/tags/v0.0.18.tar.gz"
  sha256 "c28d6c079177aa8de850e2edcbd284ac08cd3f9d77aac851928e1cc85a77fbcb"
  license "Apache-2.0"
  head "https://github.com/iximiuz/cdebug.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88d9b43ad44eef49ab960108d8f8398cc861d6784b05ee6149eefab7ecadcad4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88d9b43ad44eef49ab960108d8f8398cc861d6784b05ee6149eefab7ecadcad4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88d9b43ad44eef49ab960108d8f8398cc861d6784b05ee6149eefab7ecadcad4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1244c280b1df7cc717d7c0563e46e1957adbc8bab5dadb780291beb49621a37a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "288614fb059ed83c3a001434c918121bedb62bede3b6ddd3f717bbae02e11c9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da3c0eb9e6d8df7b8a0e3c22806078e59970c20157f2d1b0bc2e8ab5fd81c983"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cdebug", shell_parameter_format: :cobra)
  end

  test do
    # need docker daemon during runtime
    expected = if OS.mac?
      "cdebug: Cannot connect to the Docker daemon"
    else
      "cdebug: Permission denied while trying to connect to the Docker daemon socket"
    end
    assert_match expected, shell_output("#{bin}/cdebug exec nginx 2>&1", 1)

    assert_match "cdebug version #{version}", shell_output("#{bin}/cdebug --version")
  end
end
