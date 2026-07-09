class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://github.com/neilberkman/clippy/archive/refs/tags/v1.6.9.tar.gz"
  sha256 "89f2dc66c992f5f0121018232be7b98c5cc3434db64708f881fcdd644be555c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df666d1aec3cca44aec2734a077726f4b39e12d148aa3d063c092b691363708e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd1051fd3c1af38fcf151d5393acfacb8a7a53443e50b7ec9329ae817443ae09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdea6fe9fb7fe7b2089719eb1aff7f2274b9863f702e944fd9d3530ddab0e576"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9807ccb9f2c88e85b17381ff5311a9750b3f24dbfd16268d11f2cfcbd977b85"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    ldflags = %W[
      -s -w
      -X github.com/neilberkman/clippy/cmd/internal/common.Version=#{version}
      -X github.com/neilberkman/clippy/cmd/internal/common.Commit=#{tap.user}
      -X github.com/neilberkman/clippy/cmd/internal/common.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/clippy"
    system "go", "build", *std_go_args(ldflags:, output: bin/"pasty"), "./cmd/pasty"

    %w[clippy pasty].each do |cmd|
      generate_completions_from_executable(bin/cmd, shell_parameter_format: :cobra)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clippy --version")
    assert_match version.to_s, shell_output("#{bin}/pasty --version")

    (testpath/"test.txt").write("test content")
    system bin/"clippy", "-t", testpath/"test.txt"
  end
end
