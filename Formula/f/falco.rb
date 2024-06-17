class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "2871d575f3ed5df2213ff06763712785e4da49f4202d153ba52e8d0c5c930157"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f149251816cd2790a0a30f3fa12370e1eb3e2a6349494c793d84084ba9f1694"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d490496ed02c85b6cb48a13d562c36c24dd7875daba30e22dcacc6d49903d41e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce9e48e02826cad5db26579db78702d9262df88b1548b03a099db33ce95a8a63"
    sha256 cellar: :any_skip_relocation, sonoma:         "562480ac32c982341b80460805f3e0197c322c937d91420d68ce45123697dd86"
    sha256 cellar: :any_skip_relocation, ventura:        "8cdeb5143a2aa90527fe84836b40852a5686753b9426eb5e57ff50e19114989d"
    sha256 cellar: :any_skip_relocation, monterey:       "ebe5b3d9e510b001c8e37cdbf7f88d6132641bc18a7696b152442489c1a496e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dbdf387d427f1a883f2d44410777554aae45ac4461d65d6544c3e2fe57fd12f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/falco"
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
      shell_output("#{bin}/falco #{fail_vcl} 2>&1")
  end
end
