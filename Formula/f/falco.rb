class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "db65c42757922c74c1ad34eea6c13bec970b92e7202f06eac7fa4ba5ba8ebbe1"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf48bf74832c36f7e29928805f68f437af79c611daa3436bcbe198f94c6e616b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf48bf74832c36f7e29928805f68f437af79c611daa3436bcbe198f94c6e616b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf48bf74832c36f7e29928805f68f437af79c611daa3436bcbe198f94c6e616b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e24213c3edce989b03cc999d27ec840c14eda32c44c847ea91c46f457a992605"
    sha256 cellar: :any_skip_relocation, ventura:       "e24213c3edce989b03cc999d27ec840c14eda32c44c847ea91c46f457a992605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e9c20ad4e12d5f5d45b9f8370382fcebc923c3765be3598e834b5458123c3b4"
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
