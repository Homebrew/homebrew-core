class F2 < Formula
  desc "Command-line batch renaming tool"
  homepage "https://github.com/ayoisaiah/f2"
  url "https://github.com/ayoisaiah/f2/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "8b0776bdbde03041191d5d307a8f5b5aa8e87eb4380fb28f4c15d23975287a30"
  license "MIT"
  head "https://github.com/ayoisaiah/f2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0853ce2da036fbc32572f8f7dd3431776ba12e634e10e193b3663207b8b5cbdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0853ce2da036fbc32572f8f7dd3431776ba12e634e10e193b3663207b8b5cbdd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0853ce2da036fbc32572f8f7dd3431776ba12e634e10e193b3663207b8b5cbdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8291620aa08cd378c056224a6acb2735f96c3e1ce0712bfd696b0ff0335b29f"
    sha256 cellar: :any_skip_relocation, ventura:       "b8291620aa08cd378c056224a6acb2735f96c3e1ce0712bfd696b0ff0335b29f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cd393b6f4e925a9e15ada03637aa261ad154eb8e90a155b73105c858d96e0ba"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd..."
  end

  test do
    touch "test1-foo.foo"
    touch "test2-foo.foo"
    system bin/"f2", "-s", "-f", ".foo", "-r", ".bar", "-x"
    assert_predicate testpath/"test1-foo.bar", :exist?
    assert_predicate testpath/"test2-foo.bar", :exist?
    refute_predicate testpath/"test1-foo.foo", :exist?
    refute_predicate testpath/"test2-foo.foo", :exist?
  end
end
