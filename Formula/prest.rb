class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.0.2.tar.gz"
  sha256 "73929863035bc9dfac156484c02005938d2aa64ad5e160aa9c349e925dc9cd93"
  license "MIT"
  head "https://github.com/prest/prest.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "194d431f1723c23f8a074753447159e6cfda53e7312a554e28952b7742dd6895" => :catalina
    sha256 "b9278e8a7863a8e63e2f9bbdbf50aa7d97f354d54c421bf6442c6c7ffaec8522" => :mojave
    sha256 "d2ad5f27bac070fb8a4113c67accb6cf1f4280c03623577aa87e28bfed139f17" => :high_sierra
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
