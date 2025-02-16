class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/refs/tags/v3.9.7.tar.gz"
  sha256 "a2dc89951ffb4421eacc992e248ae84e8ba9a971989b47707ed9faf53cc7a519"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e16c4c3187374f9874bf0fc7c67363e62d21710665d4724dd7397a9ca9360ed9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e16c4c3187374f9874bf0fc7c67363e62d21710665d4724dd7397a9ca9360ed9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e16c4c3187374f9874bf0fc7c67363e62d21710665d4724dd7397a9ca9360ed9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4242f6ae0c1e2484069223aebfd992f07eafddd44e77252a42a1734ed99e1c0"
    sha256 cellar: :any_skip_relocation, ventura:       "c4242f6ae0c1e2484069223aebfd992f07eafddd44e77252a42a1734ed99e1c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9f03fe4dae8654f3365f0bdfbe2841097272c827b5cebe577ccd615901cb6ef"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"baidupcs-go", "run", "touch", "test.txt"
    assert_path_exists testpath/"test.txt"
  end
end
