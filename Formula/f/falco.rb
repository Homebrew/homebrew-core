class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "0658f2db1c06d5b48ecac63d07b979f20a46d86521a8433c9756bad657c729c6"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d66d0c6f07732486ce9818064b663e8d610018c6c84c67ba4c1fbd6d1dc5b7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d66d0c6f07732486ce9818064b663e8d610018c6c84c67ba4c1fbd6d1dc5b7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d66d0c6f07732486ce9818064b663e8d610018c6c84c67ba4c1fbd6d1dc5b7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "09a969c41118df9f68a9ecf91d7398cc2c9c4ef08f0c120d95e4620c7b7600a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3fc6d8d4f1b325aa6d96d50a8e3920de97c1b34ffca9d4bc84febf30eb7be25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "785d097b7299cd10c4b3bf3b719c0d22d231acb07b0f16a16ce455ff2dbc7aba"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/falco"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/falco -V 2>&1")

    pass_vcl = testpath/"pass.vcl"
    pass_vcl.write <<~EOS
      sub vcl_recv {
      #FASTLY RECV
        return (pass);
      }
    EOS

    assert_match "VCL looks great", shell_output("#{bin}/falco #{pass_vcl} 2>&1")

    fail_vcl = testpath/"fail.vcl"
    fail_vcl.write <<~EOS
      sub vcl_recv {
      #FASTLY RECV
        set req.backend = httpbin_org;
        return (pass);
      }
    EOS
    assert_match "Type mismatch: req.backend requires type REQBACKEND",
      shell_output("#{bin}/falco #{fail_vcl} 2>&1", 1)
  end
end
