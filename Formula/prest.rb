class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.0.1.tar.gz"
  sha256 "edb86fa7c799ec5c38526cb04a81c113b8180e18d3687044f7751d4caea6e50b"
  license "MIT"
  head "https://github.com/prest/prest.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c929b58cc839646a134215bee73479cbe9137063ec4e332b96f2767d74bd4ea9" => :catalina
    sha256 "558e69bd8d357559a1f963005a6c0315c0008e291b4814f59e60f6cdfd65a017" => :mojave
    sha256 "e50f082a59a2b20b1fdd6af5637811f6ae8eaeee5101e39e55e1a2bb55438206" => :high_sierra
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
