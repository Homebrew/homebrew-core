class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "013c5deb43264afc2f17a2f059fa27a706464abb235af401acfda26bb45fd8e7"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcaea34679b7343fb069bce382835e6137d39c786490ebf2004738560617856b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcaea34679b7343fb069bce382835e6137d39c786490ebf2004738560617856b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dcaea34679b7343fb069bce382835e6137d39c786490ebf2004738560617856b"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc5ce0829256592c680465d1b0b571c6a6470f47773ae51d96071fc644fbf48c"
    sha256 cellar: :any_skip_relocation, ventura:       "dc5ce0829256592c680465d1b0b571c6a6470f47773ae51d96071fc644fbf48c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42365a8e11c5adcc42034c915b993f977b0d83542a35c6466f4876c0d2de7417"
  end

  depends_on "go" => :build

  def install
    # see comment, https://github.com/Homebrew/homebrew-core/pull/217383#issuecomment-2766058674
    odie "Revert the version check for 0.58.0" if build.stable? && version > "0.58.0"

    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"k6", "completion")
  end

  test do
    (testpath/"whatever.js").write <<~JS
      export default function() {
        console.log("whatever");
      }
    JS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")

    system bin/"k6", "version"
  end
end
