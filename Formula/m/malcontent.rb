class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "f229e52403fb00c9cb0f2d19310660184f2bda8ea7d520b98db23269fe5fa7ff"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "41a8d62e8945df9628fc55ca04803d3a32051e5c725b15d98032a8939a7168bd"
    sha256 cellar: :any,                 arm64_sonoma:  "fe4532471af16f18135ebeb86ec40b40af89488f54166da91ec66ecfaab3d809"
    sha256 cellar: :any,                 arm64_ventura: "a5ab74966b579bc84f5da3d3677f91ba8a3a5acddb850dcf8c75571c4e59ad04"
    sha256 cellar: :any,                 sonoma:        "c0d5f74fe481a4ccd70a91ca1778d35e21356bf6ac8599f2e27f15ae4a09f48f"
    sha256 cellar: :any,                 ventura:       "aaeac412d10c25cd189096ea4e67d8204d512f6305abae71d01459fe1abb88a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8a264951be3b9d8008022cdeb51896004bd30abc354a46c83891fbde2e31a30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1ea0260d81e446dd7440a8718b8c4e0195427696c5c056d1e87a0f5c11cc8c6"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.BuildVersion=#{version}", output: bin/"mal"), "./cmd/mal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mal --version")

    (testpath/"test.py").write <<~PYTHON
      import subprocess
      subprocess.run(["echo", "execute external program"])
    PYTHON

    assert_match "program — execute external program", shell_output("#{bin}/mal analyze #{testpath}")
  end
end
