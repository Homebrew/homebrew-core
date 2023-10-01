class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "91f8f4849891e72a5ee732e10e134e81c565df486715b5fca746f4310aa4c9cd"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e47b5b6348dad4bb035855f24931ad3b689f0d2e280961daa8dff2bcb05e420"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "654a8161c2922f3f300c9652e5940bfba19abff5cba06945376f2023ee9573b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe18424315a0c16dc5c6820bd1e5332b2165b05186641e077b7e5f715635f2c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5141fcd9e8a9f74051f31880c0f54dfdb4d31dc2bc379e5acd1bbeab4d4bedd8"
    sha256 cellar: :any_skip_relocation, sonoma:         "0476b7cfa96565b67af027440a0da85cf19e4b309b272e85d8d954222a0ac5fc"
    sha256 cellar: :any_skip_relocation, ventura:        "e3544996d0f846c98f6a511fa62b7ba73a00eebc5f353c9f3ea9cd040a8764a2"
    sha256 cellar: :any_skip_relocation, monterey:       "ead096cd6b94190c35fa5e9b0d1bf2c8af34eb81565a421e043268870b147a31"
    sha256 cellar: :any_skip_relocation, big_sur:        "20c9204e3e05a4c79e39aaa7953913535c64c28965748b3f1e697ade301f46b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "178f7ee9d403f808e2905a3cb8df7335c372026e22bb9594dbbd6d965573d488"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/falco"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/falco -V 2>&1", 1)

    pass_vcl = testpath/"pass.vcl"
    pass_vcl.write <<~EOS
      sub vcl_recv {
      #Fastly recv
        return (pass);
      }
    EOS

    assert_match "VCL looks great", shell_output("#{bin}/falco #{pass_vcl} 2>&1")

    fail_vcl = testpath/"fail.vcl"
    fail_vcl.write <<~EOS
      sub vcl_recv {
      #Fastly recv
        set req.backend = httpbin_org;
        return (pass);
      }
    EOS
    assert_match "Type mismatch: req.backend requires type REQBACKEND",
      shell_output("#{bin}/falco #{fail_vcl} 2>&1", 1)
  end
end
