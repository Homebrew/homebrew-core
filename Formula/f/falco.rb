class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "1b92d86ff014fca05e56d3522362ec4947ed3743f4efcd7041d4fdda69d0703b"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "834b0d1bbd198697edcae2996331006421d600edb55d4561101166f314993159"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2121dc08b2cc2e6c793eba15ee0a2f5c47738ffe5868a46f81375a8cd51ceff4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2121dc08b2cc2e6c793eba15ee0a2f5c47738ffe5868a46f81375a8cd51ceff4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2121dc08b2cc2e6c793eba15ee0a2f5c47738ffe5868a46f81375a8cd51ceff4"
    sha256 cellar: :any_skip_relocation, sonoma:        "36e7f914791e3c758460a2f4c42460205e0b139c66923deade23828e04a4da11"
    sha256 cellar: :any_skip_relocation, ventura:       "36e7f914791e3c758460a2f4c42460205e0b139c66923deade23828e04a4da11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e23061f82fc96e1c79362b91044a743e4f965fe51d52ef8ff82610a9631c1864"
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
