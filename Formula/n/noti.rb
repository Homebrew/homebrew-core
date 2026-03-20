class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/refs/tags/3.8.0.tar.gz"
  sha256 "b637b4b4e5eb10b3ea2c5b2cf0fbd1904ab8fd26eaec4b911f4ce2db3ab881a2"
  license "MIT"
  head "https://github.com/variadico/noti.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9df5cb0595eeccab3df88d19535d8c4959ddb31edebd05ebdaab5f256698a528"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9ce62a753d38d76f7a0da4cd1ab463085f72ccd18a5322f285ed0fda14f31b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c6d37577bbc6a96195d28e194a129490f2d87b9afc15639bc80418f60ff598e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f755675d0005c92a27b5505e203225dfe64b9bf6715b49bb7840850454c5546"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d00980419a447dfbf768ee6cbe98155fe6359b77a860cbfd05977b9d07fb515e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57b3aa7759166c18af61e9a49704e7673f7b9f439eb562447d4bf12c3d6baaec"
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
