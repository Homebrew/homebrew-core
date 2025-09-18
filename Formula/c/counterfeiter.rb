class Counterfeiter < Formula
  desc "Tool for generating self-contained, type-safe test doubles in go"
  homepage "https://github.com/maxbrunsfeld/counterfeiter"
  url "https://github.com/maxbrunsfeld/counterfeiter/archive/refs/tags/v6.12.0.tar.gz"
  sha256 "243a7bf5bc1a9c5a6706a02167484095dea53117ddff85a95c3bbe6e6f747ad7"
  license "MIT"
  head "https://github.com/maxbrunsfeld/counterfeiter.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "130d2eceffe514edcb9963172d3ba53e4f7f305c6bcba02a1b017f04bf6d66d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "130d2eceffe514edcb9963172d3ba53e4f7f305c6bcba02a1b017f04bf6d66d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "130d2eceffe514edcb9963172d3ba53e4f7f305c6bcba02a1b017f04bf6d66d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "130d2eceffe514edcb9963172d3ba53e4f7f305c6bcba02a1b017f04bf6d66d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1885bde70e3079aae4cdab53b2f9dcdb26d8858216b032fa08c62aabb1707fd3"
    sha256 cellar: :any_skip_relocation, ventura:       "1885bde70e3079aae4cdab53b2f9dcdb26d8858216b032fa08c62aabb1707fd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d77971fadf28f655e931e5be98eef407164e43ddf83920f24e005e429d5b3d7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddf079abd97a86edf1595a3b43b5f04783f0fdd6ccd69f8a127e6d672c7a81cb"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GOROOT"] = Formula["go"].opt_libexec

    output = shell_output("#{bin}/counterfeiter -p os 2>&1")
    assert_path_exists testpath/"osshim"
    assert_match "Writing `Os` to `osshim/os.go`...", output

    output = shell_output("#{bin}/counterfeiter -generate 2>&1", 1)
    assert_match "no buildable Go source files", output
  end
end
