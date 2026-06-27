class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://github.com/toitlang/jaguar/archive/refs/tags/v1.67.0.tar.gz"
  sha256 "187630eaeb918ff7c9bdeff24c0910ae6e8fa30d795fe612473fee3245ea6671"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9107392bd82abf48449bc7a86b467b914b3c09918806a298e8ebcf5cd6b01a27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9107392bd82abf48449bc7a86b467b914b3c09918806a298e8ebcf5cd6b01a27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9107392bd82abf48449bc7a86b467b914b3c09918806a298e8ebcf5cd6b01a27"
    sha256 cellar: :any_skip_relocation, sonoma:        "425b534c33e7c2c23779dac264911610f2e9b0265d2bfcca50a039b42251d86c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0915cc59922009f85dda5c8ca03aedefd2491dd03861ca7f7d0464d132e68569"
    sha256 cellar: :any,                 x86_64_linux:  "45fbec6a5222cbe5c810479dee0a633035cfa487842e96da2ae4dc01b035824f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.buildDate=#{time.iso8601}
      -X main.buildMode=release
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"jag"), "./cmd/jag"

    generate_completions_from_executable(bin/"jag", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Version:\t v#{version}", shell_output("#{bin}/jag --no-analytics version 2>&1")

    (testpath/"hello.toit").write <<~TOIT
      main:
        print "Hello, world!"
    TOIT

    # Cannot do anything without installing SDK to $HOME/.cache/jaguar/
    assert_match "You must setup the SDK", shell_output("#{bin}/jag run #{testpath}/hello.toit 2>&1", 1)
  end
end
