class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.0.3.tar.gz"
  sha256 "3035e59926967f8f7e094b08c1287681a1e7e53b80c5fd6566a6a9fc9d90115e"
  license "MIT"
  revision 1
  head "https://github.com/prest/prest.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "db7bf2a98e2bd86e5c224d1e50ea37dfdaa9d905b3c0409d5b969b332582264d" => :catalina
    sha256 "b35ddf5dec081f7038552b275b80b5e69a610dfdb74bcdf04d1f56ef24eafce5" => :mojave
    sha256 "1278bbd3a843ef9c4948320402f1acdfeba8e8da97d78ffdc521b05af960d7be" => :high_sierra
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
