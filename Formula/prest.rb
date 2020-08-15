class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.0.3.tar.gz"
  sha256 "bab9c2ebf3507c9724818474e597cbe4925932edcc242ed6e833c403c57a4b7b"
  license "MIT"
  head "https://github.com/prest/prest.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c7212c1113a1658b8c53d978ae95e795ce3902b8bc705425cd96b019cd024dd" => :catalina
    sha256 "644feaf5d91eb242d5cce6844fbd69d228c5fe06353788abf16feaca3c87529c" => :mojave
    sha256 "22822327eeabeecbc63b19c8bde15f3b2e0c602f39214a26728d366f10449020" => :high_sierra
  end

  depends_on "go" => :build

  def install
    cd "cmd/prestd" do
      system "go", "build", *std_go_args, "-ldflags",
            "-s -w -X github.com/prest/helpers.PrestVersionNumber=#{version}"
    end
  end

  test do
    output_regex = /Version (?<migration>\d+) migration files created in .*:/
    output = shell_output("prest migrate create test --path .")
    migration = output.match(output_regex)[:migration]
    assert_predicate testpath/"#{migration}_test.down.sql", :exist?
    assert_predicate testpath/"#{migration}_test.up.sql", :exist?
  end
end
