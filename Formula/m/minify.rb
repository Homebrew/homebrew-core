class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://github.com/tdewolff/minify/archive/refs/tags/v2.24.25.tar.gz"
  sha256 "900bc080ae8a7da38eb6f78259392479abbf0a0ca8d81addd2230ff6dbbc9520"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "39a2f8065667b1211ce8becabaf820c1c21e47ff0b3629bc07ff7ac26699be60"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "39a2f8065667b1211ce8becabaf820c1c21e47ff0b3629bc07ff7ac26699be60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "39a2f8065667b1211ce8becabaf820c1c21e47ff0b3629bc07ff7ac26699be60"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0ee143cfa8e14d54c078ec0a9af5f2dc0339e7dbf3b3078a88ee477652306c1e"
    sha256 cellar: :any,                 x86_64_linux:      "7c4c1c0cf244c505f886df3f90f99300171dba4725c774832c33109e4e91e9ec"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/minify"
    bash_completion.install "cmd/minify/bash_completion"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minify --version")

    (testpath/"test.html").write <<~HTML
      <div>
        <div>test1</div>
        <div>test2</div>
      </div>
    HTML
    assert_equal "<div><div>test1</div><div>test2</div></div>", shell_output("#{bin}/minify test.html")
  end
end
