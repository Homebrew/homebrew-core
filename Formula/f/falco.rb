class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "9a92e85dea65f1eebec5134f8921c21c98618e24966925a01c20dc6206b09519"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "086b2b76fad2f0dd4b8ea6649e83bf0ef92993017af5a54ff8bc99767ce33b31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "086b2b76fad2f0dd4b8ea6649e83bf0ef92993017af5a54ff8bc99767ce33b31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "086b2b76fad2f0dd4b8ea6649e83bf0ef92993017af5a54ff8bc99767ce33b31"
    sha256 cellar: :any_skip_relocation, sonoma:        "d47997207c542444f842cd29eacb1e8640303c7f0567f406f7c4dd0c582d56e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38ef3869019f89c1e828e7de5ef9edc49408d22d515c501e6858a4cca998cb1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25fb4c8711a5b526df05f7ad4d76f9a439c7fa9229c90c55d1ce6b1a9b0d94bb"
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
