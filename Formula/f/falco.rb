class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "34570ed5effcbe6c0ccf20fc54eac1eb7faface16014cffaa6725811b4e124b6"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95e0f952d4b21bf2f22bee1b2d55f62f8ba5d225188a04fe58af377c81d9b56e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1c2f6ee0711f58c6af7adfa5f70028a3ce6fac343058cc5bf92b10e11aa4c1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "180bf20dcdec0bd3e618cac590ca5aa69583851e3c42f8a28d006a5339646c45"
    sha256 cellar: :any_skip_relocation, sonoma:         "d509ee6d0b20a8f0d12e160ec6c22967e3170b5a05e9ffca6f3ecb44a492b073"
    sha256 cellar: :any_skip_relocation, ventura:        "3e28793ce95556f0504cd73c24c0d9689d52241e1ae3774b8177e4ed3b0cb9a9"
    sha256 cellar: :any_skip_relocation, monterey:       "70bf192b811a00dfee18a470c951c0df3f44d44a1ef4da5116d2edd0e6fb9e6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a571851820f6919d3ef258787cc297bb3d58631bd0b9f11f518ecbbeb20a046"
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
