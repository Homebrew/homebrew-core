class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.0.4.tar.gz"
  sha256 "c1025c368c6276530416ef4027150439fe90dbe094199875605b6f9ecb5423c3"
  license "MIT"
  head "https://github.com/prest/prest.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2e4cc803bb566b6cb6830a53f352be4c4e8c9c78dbb04f2435701dab0f99573" => :catalina
    sha256 "14ef45283f8929b42c5e59bb839b61095cc3e4a24b2e84abfdc79f728aa6c4bb" => :mojave
    sha256 "a13ddc33929a7f5c1b2951c199a36c2b87704e4b5b4fa0ddb1bfb45cdf3f9060" => :high_sierra
  end

  depends_on "go" => :build

  def install
    cd "cmd/prestd" do
      system "go", "build", *std_go_args, "-ldflags",
            "-s -w -X github.com/prest/helpers.PrestVersionNumber=#{version}"
    end
  end

  test do
    output = shell_output("prest migrate up --path .", 255)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("prest version")
  end
end
