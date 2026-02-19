class Jsonfmt < Formula
  desc "Like gofmt, but for JSON files"
  homepage "https://github.com/caarlos0/jsonfmt"
  url "https://github.com/caarlos0/jsonfmt/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "07494aaec99d4c8cd7f0cea1bacd32e1d20321e541848aa6aafa64d64d89c9ab"
  license "MIT"
  head "https://github.com/caarlos0/jsonfmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1caa20819c76600db0ef8666a3e5cc1fc6097cf9e3303b7af167d12c2fc051c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1caa20819c76600db0ef8666a3e5cc1fc6097cf9e3303b7af167d12c2fc051c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1caa20819c76600db0ef8666a3e5cc1fc6097cf9e3303b7af167d12c2fc051c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f48c511281dfb806c106af5602434393b9c11335828330c95b657a900487a5ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c7eb81b56d9a026667d9168a0671d516966b644197c8ab0ca609c322752effe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a344c9a3d2b01667b7d8c9627f5e74bbaf367db98725d96ab5e449464b539475"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsonfmt --version")

    (testpath/"test.json").write <<~JSON
      {"foo":"bar","baz":{"qux":"quux","corge":"grault"}}
    JSON

    expected_output = <<~JSON
      {
        "foo": "bar",
        "baz": {
          "qux": "quux",
          "corge": "grault"
        }
      }
    JSON

    system bin/"jsonfmt", "--write", testpath/"test.json"
    assert_equal expected_output, (testpath/"test.json").read
  end
end
