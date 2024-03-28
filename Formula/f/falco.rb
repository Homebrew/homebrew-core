class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "ea9acd6e414389fff841169939b4b2cc2f3a675b24cb2472b22faee830d564fa"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "238b35e53862d7ec425d418907423c245ed975b46f3ed6aef92c8ad1155a45a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21f0aff28b7643918ea78f88069b4d68e412076fb8cf9c80eadb112042677972"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc86c2fe7671d008b047d5226ec3365f839ce0e4688c4cb536e12e4e547d2fd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "85bdf890123c3b6fa1bbdebf87470c8c263876fd8a93f3e80e80e02a9853280c"
    sha256 cellar: :any_skip_relocation, ventura:        "ca89cff918c5caddafe2597f3c898a5d235d5ba582c2ae182bb9e031b6bb38fb"
    sha256 cellar: :any_skip_relocation, monterey:       "bc7003c1879b8ab82aec31d752dd139bf435ce92504d400e678ad964da4467ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1099b737d771abb999cb86b03d7eadaed2c967908d8f89b5cec9645bc5ca97ca"
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
      shell_output("#{bin}/falco #{fail_vcl} 2>&1", 1)
  end
end
