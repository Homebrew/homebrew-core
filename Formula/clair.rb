class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v2.1.4.tar.gz"
  sha256 "444e109091ddc49e00277e38ddf9456a53243ab70f2560ab927f4d35b53555f4"
  license "Apache-2.0"

  depends_on "go" => :build
  depends_on "rpm"
  depends_on "xz"

  def install
    system "go", "build", *std_go_args, "./cmd/clair"
    (etc/"clair").install "config.example.yaml" => "config.yaml"
  end

  test do
    cp etc/"clair/config.yaml", testpath
    output = shell_output("#{bin}/clair -config=config.yaml", 1)
    # requires a Postgres database
    assert_match "pgsql: could not open database", output
  end
end
