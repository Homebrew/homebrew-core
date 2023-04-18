class Gmailctl < Formula
  desc "Declarative configuration for Gmail filters"
  homepage "https://github.com/mbrt/gmailctl"
  url "https://github.com/mbrt/gmailctl/archive/v0.10.6.tar.gz"
  sha256 "85757469561fd612209c8d7c5146b4a23d377d236a918c1636113c3d115acf60"
  license "MIT"
  head "https://github.com/mbrt/gmailctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f94ddd5b80ac901282cb4e9d6ab837f0260c16ced3b1b47ea3d960d50a68cfd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8f85806b696fe87c80b9769dba5c2e7aeaccbda8a2556d8ba9cab48b3a0baa3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "767e31d78fe9ce25a0bf0edffb32c923da320140428ec3b5a84b4364467386bc"
    sha256 cellar: :any_skip_relocation, ventura:        "496ad97ff738102c0d59f8483bb7888486ec6feedff9f0955a1b01aa0e3e3602"
    sha256 cellar: :any_skip_relocation, monterey:       "b5bc82815fa4e14df3d9b084c56b5e6883dadf09dbf4b728d28fe48e1c94620e"
    sha256 cellar: :any_skip_relocation, big_sur:        "74c1212da4c70372c8cf1149f2f04ce7677217108e06ecec6f8bfdab764d795a"
    sha256 cellar: :any_skip_relocation, catalina:       "8ac17b8b385eb1b4b964d990ac9dc1bce622d72214f0f22a28a150cb271bbd95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "380d3964ab5cac3f3dc71b37de03e699197e433990cda2ce0aa3c3b470605fe7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "cmd/gmailctl/main.go"

    generate_completions_from_executable(bin/"gmailctl", "completion")
  end

  test do
    assert_includes shell_output("#{bin}/gmailctl init --config #{testpath} 2>&1", 1),
      "The credentials are not initialized"

    assert_match version.to_s, shell_output("#{bin}/gmailctl version")
  end
end
