class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v0.3.5.tar.gz"
  sha256 "35aa1faaa33a47526cb836562ab095bcf610dbc3da4a569eebcbab0a8dd92e7a"
  license "MIT"
  head "https://github.com/prest/prest.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "42403c1b7e35b043d8accb88602e28657a32eb2caeeebe42876b9c6989da0c4a" => :catalina
    sha256 "c9fc93350a2e7321625083a2fd5507c4f06382c2bf1155af6a48093575d7ad2c" => :mojave
    sha256 "e5421d3a1b82910dd798cb43e7fcb5a8bc37978c782814cb786df786c04f9a08" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags",
           "-s -w -X github.com/prest/helpers.PrestVersionNumber=#{version}"
  end

  test do
    output_regex = /Version (?<migration>\d+) migration files created in .*:/
    output = shell_output("prest migrate create test --path .")
    migration = output.match(output_regex)[:migration]
    assert_predicate testpath/"#{migration}_test.down.sql", :exist?
    assert_predicate testpath/"#{migration}_test.up.sql", :exist?
  end
end
